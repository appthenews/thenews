import SwiftUI

struct Loading: View {
    var body: some View {
        VStack {
            Image(systemName: "cloud.bolt")
                .font(.system(size: 60, weight: .ultraLight))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.tertiary)
            Text("Fetching news...")
                .font(.callout)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .greatestFiniteMagnitude)
        .padding(.top, 150)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listSectionSeparator(.hidden)
    }
}
