import SwiftUI

struct About: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Image("Logo")
                .foregroundColor(.accentColor)
            Text("The News")
                .font(.title.weight(.regular))
                .foregroundColor(.primary)
                .padding(.vertical, 10)
            Spacer()
            Divider()
            VStack(spacing: 0) {
                Spacer()
                Button {
                    UIApplication.shared.share(URL(string: "https://apps.apple.com/us/app/news/id1632729572?platform=iphone")!)
                } label: {
                    Image(systemName: "square.and.arrow.up.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 40, weight: .light))
                        .contentShape(Rectangle())
                }
                
                Spacer()
                Text(verbatim: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "")
                    .font(.body.monospacedDigit())
                    .foregroundStyle(.secondary)
                HStack(spacing: 0) {
                    Text("From Berlin with ")
                        .foregroundStyle(.tertiary)
                        .font(.caption)
                    Image(systemName: "heart.fill")
                        .font(.footnote)
                        .foregroundStyle(.pink)
                }
                Spacer()
            }
            .frame(maxWidth: .greatestFiniteMagnitude)
            .background(Color(.secondarySystemBackground))
        }
    }
}
