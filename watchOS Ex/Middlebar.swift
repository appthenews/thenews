import SwiftUI
import News

struct Middlebar: View {
    @ObservedObject var session: Session
    let provider: Provider
    @State private var items = [Item]()
    
    var body: some View {
        List(articles, id: \.link, rowContent: link(article:))
            .navigationTitle(provider.title)
            .onReceive(session.cloud) {
                items = $0.items(provider: provider)
            }
    }
    
    private var articles: [Item] {
        items
            .filter { element in
                switch session.showing {
                case 0:
                    return true
                case 1:
                    return element.status == .new
                default:
                    return element.status == .bookmarked
                }
            }
            .sorted()
    }
    
    private func link(article: Item) -> some View {
        NavigationLink(destination: Content(session: session, item: article, provider: provider)) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 0) {
                    VStack(alignment: .leading) {
                        if provider == .all {
                            Text(verbatim: article.feed.provider.title)
                            Text(article.date, format: .relative(presentation: .named, unitsStyle: .wide))
                        } else {
                            Text(verbatim: article.date.formatted(.relative(presentation: .named, unitsStyle: .wide)).capitalized)
                        }
                    }
                    .font(.caption2.weight(.light))
                    .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    switch article.status {
                    case .new:
                        if article.recent {
                            Circle()
                                .fill(Color.accentColor)
                                .frame(width: 8, height: 8)
                        }
                    case .bookmarked:
                        Image(systemName: "bookmark.fill")
                            .font(.system(size: 13, weight: .light))
                            .foregroundColor(.secondary)
                            .symbolRenderingMode(.hierarchical)
                    default:
                        EmptyView()
                    }
                }
                
                Text(verbatim: article.title)
                    .font(.system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize + session.font, weight: .regular))
                    .foregroundColor(article.status == .new
                                     ? .primary
                                     : .secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}
