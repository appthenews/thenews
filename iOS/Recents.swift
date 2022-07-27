import SwiftUI
import News

struct Recents: View {
    @ObservedObject var session: Session
    @State private var items = [Item]()
    @State private var selection: String?
    
    var body: some View {
        ScrollViewReader { proxy in
            List(items, id: \.link, rowContent: link(article:))
                .listStyle(.plain)
                .navigationTitle("Recents")
                .navigationBarTitleDisplayMode(.large)
                .background(session.reader ? .init("Background") : Color.clear)
                .onReceive(session.cloud) {
                    items = $0.recents
                }
                .onAppear {
                    proxy.scrollTo(items.first?.link, anchor: .top)
                }
        }
    }
    
    private func link(article: Item) -> some View {
        Button {
            selection = article.link
            session.tab = 1
            
            if session.item?.link != article.link {
                if session.provider == article.feed.provider || session.provider == .all {
                    session.item = article
                } else if session.provider == nil {
                    session.provider = article.feed.provider
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        session.item = article
                    }
                } else {
                    session.provider = nil
                
                    if session.item != nil {
                        session.item = nil
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                        session.provider = article.feed.provider
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                        session.item = article
                    }
                }
            }
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(verbatim: article.feed.provider.title)
                    .foregroundColor(session.reader ? .accentColor : .secondary)
                    .font(.footnote)
                + Text(verbatim: " — ")
                    .foregroundColor(session.reader ? .accentColor : .secondary)
                    .font(.footnote.weight(.light))
                + Text(article.date, format: .relative(presentation: .named, unitsStyle: .wide))
                    .foregroundColor(session.reader ? .accentColor : .secondary)
                    .font(.footnote.weight(.light))
                Text(verbatim: article.title)
                    .font(.system(size: UIFont.preferredFont(forTextStyle: .callout).pointSize, weight: .regular))
                    .kerning(0.5)
                    .foregroundColor(session.reader ? .accentColor : .primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            .padding(.vertical, 6)
        }
        .buttonStyle(Listed {
            if $0 {
                selection = article.link
            } else if selection == article.link {
                selection = nil
            }
        })
        .listRowBackground(session.reader
                           ? selection == article.link
                                ? .accentColor.opacity(0.15)
                                : Color.clear
                           : nil)
        .id(article.link)
    }
}
