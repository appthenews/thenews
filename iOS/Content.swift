import SwiftUI
import News

struct Content: View {
    @ObservedObject var session: Session
    @State private var delete = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        if let item = session.item {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        header(item: item)
                            .id("header")
                        
                        content(item: item)
                        
                        actions(item: item)
                        
                        if session.froob {
                            Froob(session: session)
                        }
                    }
                    .textSelection(.enabled)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .padding(.vertical, 30)
                    .padding(.horizontal, 24)
                }
                .onChange(of: session.item) { _ in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        proxy.scrollTo("header", anchor: .center)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(session.reader ? .init("Background") : Color.clear)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    tools(item: item)
                }
            }
            .task {
                session.review()
            }
        } else {
            ZStack {
                Image("Logo")
                    .foregroundStyle(.quaternary)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
        }
    }
    
    @ViewBuilder private func header(item: Item) -> some View {
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
    }
    
    @ViewBuilder private func content(item: Item) -> some View {
        Text(verbatim: item.title)
            .font(.system(size: UIFont.preferredFont(forTextStyle: .title2).pointSize + session.font, weight: .medium))
            .kerning(1)
            .foregroundColor(session.reader ? .accentColor : .primary)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, 6)
            .padding(.bottom, 22)
        Text(verbatim: item.description)
            .font(.system(size: UIFont.preferredFont(forTextStyle: .body).pointSize + session.font, weight: .regular))
            .kerning(1)
            .foregroundColor(session.reader ? .accentColor : .primary)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.bottom, 30)
    }
    
    @ViewBuilder func tools(item: Item) -> some View {
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
    
    private func actions(item: Item) -> some View {
        HStack(spacing: 35) {
            Link(destination: .init(string: item.link)!) {
                Text("Article")
                    .font(.callout.weight(.medium))
            }
            .buttonStyle(.borderedProminent)
            
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
                
                Button("Cancel", role: .cancel) { }
            }
            
            button(symbol: "square.and.arrow.up", size: 18) {
                UIApplication.shared.share(URL(string: item.link)!)
            }
            
            Spacer()
        }
        .padding(.vertical, 10)
    }
    
    private func button(symbol: String, size: CGFloat, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: size, weight: .regular))
                .symbolRenderingMode(.hierarchical)
                .contentShape(Rectangle())
                .frame(width: 30, height: 44)
        }
    }
}
