import SwiftUI
import News

struct Content: View {
    let session: Session
    let link: String?
    let provider: Provider?
    @State private var item: Item?
    
    var body: some View {
        if let link = link, let provider = provider {
            ScrollView {
                if let item = item {
                    VStack(alignment: .leading, spacing: 0) {
                        if provider == .all {
                            Text(verbatim: item.feed.provider.title)
                                .font(.callout)
                                .foregroundColor(.secondary)
                            + Text(verbatim: " — ")
                                .font(.callout.weight(.light))
                                .foregroundColor(.secondary)
                            + Text(item.date, format: .relative(presentation: .named, unitsStyle: .wide))
                                .font(.callout.weight(.light))
                                .foregroundColor(.secondary)
                        } else {
                            Text(verbatim: item.date.formatted(.relative(presentation: .named, unitsStyle: .wide)).capitalized)
                                .font(.callout.weight(.light))
                                .foregroundColor(.secondary)
                        }
                        Text(verbatim: item.title)
                            .font(.title2.weight(.medium))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.vertical, 22)
                        Text(verbatim: item.description)
                            .font(.body.weight(.regular))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .textSelection(.enabled)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .padding(22)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if let item = item {
                        button(symbol: "trash") {
                            
                        }
                        
                        button(symbol: "square.and.arrow.up") {
                            
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
                        
                        button(image: "IconSmall") {
                            
                        }
                    }
                }
            }
            .onReceive(session.cloud) {
                item = $0
                    .items(provider: provider)
                    .first {
                        $0.link == link
                    }
                
                print(item!.status)
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
    
    private func button(image: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(image)
                .contentShape(Rectangle())
                .frame(width: 34, height: 40)
        }
    }
}
