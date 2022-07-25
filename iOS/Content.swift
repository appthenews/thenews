import SwiftUI
import News

struct Content: View {
    let session: Session
    let provider: Provider?
    let item: Item?
    
    var body: some View {
        if let item = item, let provider = provider {
            ScrollView {
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
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                .padding(22)
            }
            .navigationBarTitleDisplayMode(.inline)
        } else {
            Image("Icon")
                .foregroundStyle(.secondary)
        }
    }
}
