import SwiftUI
import News

struct Middlebar: View {
    @ObservedObject var session: Session
    @State private var selection: String?
    
    var body: some View {
        NavigationLink(destination: Content(session: session), tag: true, selection: .init(get: {
            session.item != nil
        }, set: {
            if $0 != true {
                session.item = nil
            }
        })) { }
        
        ScrollViewReader { proxy in
            List {
                if session.filters {
                    Picker("Showing", selection: $session.showing) {
                        Text(verbatim: "All")
                            .tag(0)
                        Text(verbatim: "Not read")
                            .tag(1)
                        Text(verbatim: "Bookmarks")
                            .tag(2)
                    }
                    .pickerStyle(.segmented)
                    .listRowBackground(Color.clear)
                    .listSectionSeparator(.hidden)
                }
                
                Text(verbatim: session.provider == nil
                     ? ""
                     : session.articles.count.formatted() + (session.articles.count == 1
                                                             ? " article"
                                                             : " articles"))
                .font(.callout.monospacedDigit())
                .foregroundColor(session.reader ? .accentColor : .secondary)
                .listRowBackground(Color.clear)
                .listSectionSeparator(.hidden)
                
                ForEach(session.articles, id: \.link, content: link(article:))
            }
            .listStyle(.plain)
            .searchable(text: $session.search)
            .navigationTitle(session.provider?.title ?? "")
            .navigationBarTitleDisplayMode(.large)
            .background(session.reader ? .init("Background") : Color.clear)
            .onAppear {
                proxy.scrollTo(session.item?.link, anchor: .center)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    session.filters.toggle()
                } label: {
                    Image(systemName: session.filters
                          ? "line.3.horizontal.decrease.circle.fill"
                          : "line.3.horizontal.decrease.circle")
                        .font(.system(size: 18, weight: .regular))
                        .contentShape(Rectangle())
                        .frame(width: 36, height: 36)
                }
            }
        }
    }
    
    private func link(article: Item) -> some View {
        Button {
            session.item = article
        } label: {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    if session.provider == .all {
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
                        .kerning(0.5)
                        .foregroundColor(session.reader
                                         ? article.status == .new ? .accentColor : .init(.tertiaryLabel)
                                         : article.status == .new ? .primary : .init(.tertiaryLabel))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                
                ZStack {
                    VStack {
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
                                .foregroundColor(session.reader ? .accentColor : .secondary)
                                .symbolRenderingMode(.hierarchical)
                        default:
                            EmptyView()
                        }
                        Spacer()
                    }
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(article.status == .new ? .init(.tertiaryLabel) : .init(.quaternaryLabel))
                }
                .frame(width: 16)
                .padding(.leading, 8)
            }
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(Listed {
            if $0 {
                selection = article.link
            } else if selection == article.link {
                selection = nil
            }
        })
        .listRowBackground(session.reader
                           ? session.item?.link == article.link || selection == article.link
                                ? .accentColor.opacity(0.15)
                                : Color.clear
                           : selection == article.link
                               ? .primary.opacity(0.1)
                               : Color.clear)
        .id(article.link)
    }
}
