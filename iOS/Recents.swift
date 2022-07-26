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
        NavigationLink(tag: article.link, selection: $selection) {
            Recent(session: session, link: article.link)
        } label: {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 6) {
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
                        .font(.system(size: UIFont.preferredFont(forTextStyle: .callout).pointSize + session.font, weight: .regular))
                        .foregroundColor(session.reader ? .accentColor : .primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                ZStack {
                    switch article.status {
                    case .bookmarked:
                        Image(systemName: "bookmark.fill")
                            .font(.system(size: 14, weight: .light))
                            .foregroundStyle(.secondary)
                            .symbolRenderingMode(.hierarchical)
                    default:
                        EmptyView()
                    }
                }
                .frame(width: 24)
                .padding(.leading, 6)
            }
            .padding(.vertical, 14)
        }
        .listRowBackground(session.reader
                           ? selection == article.link
                                ? .accentColor.opacity(0.15)
                                : Color.clear
                           : nil)
        .id(article.link)
    }
}
