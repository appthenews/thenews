import SwiftUI
import News

struct Content: View {
    @ObservedObject var session: Session
    @State private var delete = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        if let item = session.item {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 20) {
                        Spacer()
                        
                        button(symbol: "trash", size: 18) {
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
                        
                        Link(destination: .init(string: item.link)!) {
                            Text("Full article")
                                .font(.callout.weight(.medium))
                        }
                        .buttonStyle(.borderedProminent)
                        
                        button(symbol: "square.and.arrow.up", size: 18) {
                            UIApplication.shared.share(URL(string: item.link)!)
                        }
                        Spacer()
                    }
                    .padding(.top)
                    .padding(.bottom, 30)
                    
                    if session.provider == .all {
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
                        .padding(.bottom, 30)
                }
                .textSelection(.enabled)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                .padding(.horizontal, 22)
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(session.reader ? .init("Background") : Color.clear)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    button(symbol: item.status == .bookmarked ? "bookmark.fill" : "bookmark", size: 14) {
                        Task {
                            if item.status == .bookmarked {
                                await session.cloud.unbookmark(item: item)
                            } else {
                                await session.cloud.bookmark(item: item)
                            }
                        }
                    }
                    button(symbol: "chevron.up", size: 18) {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            session.previous()
                        }
                    }
                    button(symbol: "chevron.down", size: 18) {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            session.next()
                        }
                    }
                }
            }
        } else {
            Image("Icon")
                .foregroundStyle(.secondary)
        }
    }
    
    private func button(symbol: String, size: CGFloat, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: size, weight: .regular))
                .symbolRenderingMode(.hierarchical)
                .contentShape(Rectangle())
                .frame(width: 44, height: 44)
        }
    }
}
