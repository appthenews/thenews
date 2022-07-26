import SwiftUI
import News

struct Middlebar: View {
    @ObservedObject var session: Session
    let provider: Provider?
    @State private var items = [Item]()
    @State private var search = ""
    @State private var filters = false
    @State private var selection: String?
    @AppStorage("showing") private var showing = 0
    
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
        .background(session.reader ? .init("Background") : Color.clear)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    filters.toggle()
                    
                    if !filters {
                        showing = 0
                    }
                } label: {
                    Image(systemName: filters ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                        .font(.system(size: 18, weight: .regular))
                        .contentShape(Rectangle())
                        .frame(width: 36, height: 36)
                }
            }
            ToolbarItem(placement: .navigation) {
                if filters {
                    Picker("Showing", selection: $showing) {
                        Text(verbatim: "All")
                            .tag(0)
                        Text(verbatim: "Not read")
                            .tag(1)
                        Text(verbatim: "Bookmarks")
                            .tag(2)
                    }
                    .pickerStyle(.segmented)
                }
            }
        }
        .onReceive(session.cloud) {
            if let provider = provider {
                items = $0
                    .items(provider: provider)
            }
        }
        .task {
            filters = showing != 0
        }
    }
    
    private func link(article: Item) -> some View {
        NavigationLink(tag: article.link, selection: $selection) {
            Content(session: session, link: article.link, provider: provider)
        } label: {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 6) {
                    if provider == .all {
                        Text(verbatim: article.feed.provider.title)
                            .foregroundColor(session.reader
                                             ? article.status == .new ? .accentColor : .init(.tertiaryLabel)
                                             : article.status == .new ? .secondary : .init(.tertiaryLabel))
                            .font(.footnote)
                        + Text(verbatim: " — ")
                            .foregroundColor(session.reader
                                             ? article.status == .new ? .accentColor : .init(.tertiaryLabel)
                                             : article.status == .new ? .secondary : .init(.tertiaryLabel))
                            .font(.footnote.weight(.light))
                        + Text(article.date, format: .relative(presentation: .named, unitsStyle: .wide))
                            .foregroundColor(session.reader
                                             ? article.status == .new ? .accentColor : .init(.tertiaryLabel)
                                             : article.status == .new ? .secondary : .init(.tertiaryLabel))
                            .font(.footnote.weight(.light))
                    } else {
                        Text(verbatim: article.date.formatted(.relative(presentation: .named, unitsStyle: .wide)).capitalized)
                            .foregroundColor(session.reader
                                             ? article.status == .new ? .accentColor : .init(.tertiaryLabel)
                                             : article.status == .new ? .secondary : .init(.tertiaryLabel))
                            .font(.footnote.weight(.light))
                    }
                    
                    Text(verbatim: article.title)
                        .font(.system(size: UIFont.preferredFont(forTextStyle: .callout).pointSize + session.font, weight: .regular))
                        .foregroundColor(session.reader
                                         ? article.status == .new ? .accentColor : .init(.tertiaryLabel)
                                         : article.status == .new ? .primary : .init(.tertiaryLabel))
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                ZStack {
                    switch article.status {
                    case .new:
                        if article.recent {
                            Circle()
                                .fill(Color.accentColor)
                                .frame(width: 8, height: 8)
                        }
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
                           ? selection == article.link ? nil : Color.clear
                           : nil)
    }
    
    private var articles: [Item] {
        items
            .filter { element in
                switch showing {
                case 0:
                    return true
                case 1:
                    return element.status == .new
                default:
                    return element.status == .bookmarked
                }
            }
            .filter(search: search)
            .sorted()
    }
}
