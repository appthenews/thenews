import SwiftUI
import News

struct Content: View {
    @ObservedObject var session: Session
    let link: String?
    let provider: Provider?
    @State private var item: Item?
    @State private var delete = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        if let link = link {
            ScrollView {
                if let item = item {
                    VStack(alignment: .leading, spacing: 0) {
                        if provider == nil || provider == .all {
                            Text(verbatim: item.feed.provider.title)
                                .font(.callout)
                                .foregroundColor(session.reader ? .accentColor : .secondary)
                            + Text(verbatim: " — ")
                                .font(.callout.weight(.light))
                                .foregroundColor(session.reader ? .accentColor : .secondary)
                            + Text(item.date, format: .relative(presentation: .named, unitsStyle: .wide))
                                .font(.callout.weight(.light))
                                .foregroundColor(session.reader ? .accentColor : .secondary)
                        } else {
                            Text(verbatim: item.date.formatted(.relative(presentation: .named, unitsStyle: .wide)).capitalized)
                                .font(.callout.weight(.light))
                                .foregroundColor(session.reader ? .accentColor : .secondary)
                        }
                        
                        Text(verbatim: item.title)
                            .font(.system(size: UIFont.preferredFont(forTextStyle: .title2).pointSize + session.font, weight: .medium))
                            .foregroundColor(session.reader ? .accentColor : .primary)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.vertical, 22)
                        Text(verbatim: item.description)
                            .font(.system(size: UIFont.preferredFont(forTextStyle: .body).pointSize + session.font, weight: .regular))
                            .foregroundColor(session.reader ? .accentColor : .primary)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 10)
                    }
                    .textSelection(.enabled)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .padding(22)
                    .task {
                        if provider != nil {
                            await session.cloud.read(item: item)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(session.reader ? .init("Background") : Color.clear)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if let item = item {
                        button(symbol: "trash") {
                            delete = true
                        }
                        .confirmationDialog("Delete article?", isPresented: $delete) {
                            Button("Delete", role: .destructive) {
                                Task {
                                    await session.cloud.delete(item: item)
                                    dismiss()
                                }
                            }
                            
                            Button("Cancel", role: .cancel) {
                                delete = false
                            }
                        }
                        
                        button(symbol: "square.and.arrow.up") {
                            UIApplication.shared.share(URL(string: item.link)!)
                        }
                        
                        button(symbol: item.status == .bookmarked ? "bookmark.fill" : "bookmark") {
                            Task {
                                if item.status == .bookmarked {
                                    await session.cloud.unbookmark(item: item)
                                } else {
                                    await session.cloud.bookmark(item: item)
                                }
                            }
                        }
                        
                        Link(destination: .init(string: item.link)!) {
                            Image("IconSmall")
                                .contentShape(Rectangle())
                                .frame(width: 34, height: 40)
                        }
                    }
                }
            }
            .onReceive(session.cloud) {
                if let provider = provider {
                    item = $0
                        .items(provider: provider)
                        .first {
                            $0.link == link
                        }
                } else {
                    item = $0
                        .recents
                        .first {
                            $0.link == link
                        }
                }
            }
        } else {
            Image("Icon")
                .foregroundStyle(.secondary)
        }
    }
    
    private func button(symbol: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 14, weight: .regular))
                .symbolRenderingMode(.hierarchical)
                .contentShape(Rectangle())
                .frame(width: 30, height: 40)
        }
    }
}
