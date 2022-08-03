import SwiftUI
import News

struct Sidebar: View {
    @ObservedObject var session: Session
    @State private var providers = Set<Provider>()
    @State private var recents = Provider.allCases.reduce(into: [:]) { $0[$1] = 0 }
    
    var body: some View {
        NavigationView {
            List {
                if session.loading {
                    Image("Logo")
                        .foregroundColor(.primary)
                        .frame(maxWidth: .greatestFiniteMagnitude, minHeight: 150)
                        .listRowBackground(Color.clear)
                } else {
                    provider(provider: .all)
                    provider(provider: .theGuardian)
                    provider(provider: .reuters)
                    provider(provider: .derSpiegel)
                    provider(provider: .theLocal)
                }
            }
            .navigationTitle(session.loading ? "" : "Feeds")
        }
        .onReceive(session.cloud) { model in
            providers = model.preferences.providers
            recents = Provider
                .allCases
                .reduce(into: [:]) { result, provider in
                    if provider == .all || providers.contains(provider) {
                        result[provider] = model
                            .items(provider: provider)
                            .filter(\.recent)
                            .count
                    } else {
                        result[provider] = 0
                    }
                }
        }
    }
    
    @ViewBuilder private func provider(provider: Provider) -> some View {
        if provider == .all || providers.contains(provider) {
            NavigationLink(destination: Middlebar(session: session, provider: provider)) {
                HStack(spacing: 0) {
                    Text(verbatim: provider.title)
                        .foregroundColor(.primary)
                        .font(.callout.weight(.regular))
                    Spacer()
                    if recents[provider]! > 0 {
                        ZStack {
                            Capsule()
                                .fill(Color.accentColor)
                            Text(recents[provider]!, format: .number)
                                .font(.caption2.monospacedDigit().weight(.medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                        }
                        .fixedSize()
                    }
                }
                .padding(.vertical, 8)
                .contentShape(Rectangle())
            }
        }
    }
}
