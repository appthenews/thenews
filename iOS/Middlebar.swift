import SwiftUI
import News

struct Middlebar: View {
    let session: Session
    let provider: Provider?
    @State private var articles = [Item]()
    @State private var search = ""
    
    var body: some View {
        List {
            Section(provider == nil ? "" : articles.count.formatted() + (articles.count == 1 ? " article" : " articles")) {
                ForEach(articles, id: \.link, content: link(article:))
            }
        }
        .listStyle(.plain)
        .searchable(text: $search)
        .navigationTitle(provider?.title ?? "")
        .navigationBarTitleDisplayMode(.large)
        .onReceive(session.cloud) {
            if let provider = provider {
                articles = $0
                    .items(provider: provider)
                    .sorted()
            }
        }
    }
    
    private func link(article: Item) -> some View {
        NavigationLink(destination: Content(session: session, provider: provider, item: article)) {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 6) {
                    if provider == .all {
                        Text(verbatim: article.feed.provider.title)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        + Text(verbatim: " — ")
                            .font(.footnote.weight(.light))
                            .foregroundColor(.secondary)
                        + Text(article.date, format: .relative(presentation: .named, unitsStyle: .wide))
                            .font(.footnote.weight(.light))
                            .foregroundColor(.secondary)
                    } else {
                        Text(verbatim: article.date.formatted(.relative(presentation: .named, unitsStyle: .wide)).capitalized)
                            .font(.footnote.weight(.light))
                            .foregroundColor(.secondary)
                    }
                    Text(verbatim: article.title)
                        .font(.callout)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                ZStack {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 10, height: 10)
                }
                .frame(width: 30)
            }
            .padding(.vertical, 14)
        }
    }
}
