import SwiftUI
import News

struct Recents: View {
    @ObservedObject var session: Session
    @State private var items = [Item]()
    @State private var selection: String?
    @State private var clear = false
    
    var body: some View {
        ScrollViewReader { proxy in
            if items.isEmpty {
                ZStack {
                    Image("Logo")
                        .foregroundStyle(.quaternary)
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
            } else {
                List(items, id: \.link, rowContent: link(article:))
                    .listStyle(.plain)
                    .onAppear {
                        proxy.scrollTo(items.first?.link, anchor: .top)
                    }
            }
        }
        .animation(.easeInOut(duration: 0.4), value: items)
        .navigationTitle("Recents")
        .navigationBarTitleDisplayMode(.large)
        .background(session.reader ? .init("Background") : Color.clear)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(role: .destructive) {
                    guard !items.isEmpty else { return }
                    clear = true
                } label: {
                    Label("Clear", systemImage: "trash")
                        .font(.callout)
                        .foregroundStyle(items.isEmpty ? .tertiary : .primary)
                        .foregroundColor(session.reader ? .accentColor : .pink)
                }
                disabled(items.isEmpty)
            }
        }
        .confirmationDialog("Clear recents?", isPresented: $clear) {
            Button("Clear", role: .destructive) {
                Task {
                    await session.cloud.clear()
                }
            }
            
            Button("Cancel", role: .cancel) { }
        }
        .onReceive(session.cloud) {
            items = $0.recents
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
                           : selection == article.link
                               ? .primary.opacity(0.1)
                               : Color.clear)
        .id(article.link)
    }
}
