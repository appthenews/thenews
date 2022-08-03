import SwiftUI
import News

struct Content: View {
    @ObservedObject var session: Session
    let item: Item
    let provider: Provider
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                header(item: item)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                content(item: item)
                
                Button {
                    Task {
                        if item.status == .bookmarked {
                            await session.cloud.unbookmark(item: item)
                        } else {
                            await session.cloud.bookmark(item: item)
                        }
                    }
                } label: {
                    Image(systemName: item.status == .bookmarked ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 18, weight: .regular))
                        .symbolRenderingMode(.hierarchical)
                }
                .buttonStyle(.bordered)
                .frame(width: 60)
                .listRowBackground(Color.clear)
            }
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
        }
        .task {
            Task {
                await session.cloud.read(item: item)
            }
        }
    }
    
    @ViewBuilder private func header(item: Item) -> some View {
        Text(verbatim: item.feed.provider.title)
        Text(item.date, format: .relative(presentation: .named, unitsStyle: .wide))
    }
    
    @ViewBuilder private func content(item: Item) -> some View {
        Text(verbatim: item.title)
            .font(.system(size: UIFont.preferredFont(forTextStyle: .body).pointSize + session.font, weight: .medium))
            .foregroundColor(.primary)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, 4)
            .padding(.bottom, 10)
        Text(verbatim: item.description)
            .font(.system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize + session.font, weight: .regular))
            .foregroundColor(.primary)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.bottom, 20)
    }
}
