import SwiftUI
import News

struct Sidebar: View {
    @ObservedObject var session: Session
    @State private var providers = Set<Provider>()
    @State private var feeds = false
    @State private var recents = Provider.allCases.reduce(into: [:]) { $0[$1] = 0 }
    
    var body: some View {
        List {
            provider(provider: .all)
            provider(provider: .theGuardian)
            provider(provider: .reuters)
            provider(provider: .derSpiegel)
            provider(provider: .theLocal)
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Feeds")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $feeds) {
            NavigationView {
                Feeds(session: session)
                    .navigationTitle("Select your feeds")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                feeds = false
                            }
                        }
                    }
            }
            .navigationViewStyle(.stack)
        }
        .onReceive(session.cloud) { model in
            providers = model.preferences.providers
            
            if providers.isEmpty {
                feeds = true
            }
            
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
            NavigationLink(destination: Circle()) {
                HStack(spacing: 0) {
                    Text(provider.title)
                        .font(.body.weight(.medium))
                    Spacer()
                    if recents[provider]! > 0 {
                        ZStack {
                            Capsule()
                                .fill(Color.accentColor)
                            Text(recents[provider]!.formatted())
                                .font(.footnote.monospacedDigit().weight(.semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                        }
                        .fixedSize()
                    }
                }
                .padding(.vertical, 10)
            }
        }
    }
}
