import SwiftUI
import News

struct Content: View {
    let session: Session
    let link: String?
    let provider: Provider?
    @State private var item: Item?
    @State private var delete = false
    @AppStorage("reader") private var reader = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        if let link = link, let provider = provider {
            ScrollView {
                if let item = item {
                    VStack(alignment: .leading, spacing: 0) {
                        if provider == .all {
                            Text(verbatim: item.feed.provider.title)
                                .font(.callout)
                                .foregroundColor(reader ? Color("Text") : .secondary)
                            + Text(verbatim: " — ")
                                .font(.callout.weight(.light))
                                .foregroundColor(reader ? Color("Text") : .secondary)
                            + Text(item.date, format: .relative(presentation: .named, unitsStyle: .wide))
                                .font(.callout.weight(.light))
                                .foregroundColor(reader ? Color("Text") : .secondary)
                        } else {
                            Text(verbatim: item.date.formatted(.relative(presentation: .named, unitsStyle: .wide)).capitalized)
                                .font(.callout.weight(.light))
                                .foregroundColor(reader ? Color("Text") : .secondary)
                        }
                        
                        Text(verbatim: item.title)
                            .font(.title2.weight(.medium))
                            .foregroundColor(reader ? Color("Text") : .primary)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.vertical, 22)
                        Text(verbatim: item.description)
                            .font(.body.weight(.regular))
                            .foregroundColor(reader ? Color("Text") : .primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .textSelection(.enabled)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .padding(22)
                    .task {
                        await session.cloud.read(item: item)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(reader ? Color("Background") : Color.clear)
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
                item = $0
                    .items(provider: provider)
                    .first {
                        $0.link == link
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
