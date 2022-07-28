import SwiftUI
import News

struct Sidebar: View {
    @ObservedObject var session: Session
    @State private var providers = Set<Provider>()
    @State private var feeds = false
    @State private var recents = Provider.allCases.reduce(into: [:]) { $0[$1] = 0 }
    
    var body: some View {
        List {
            if session.loading {
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
            } else {
                provider(provider: .all)
                provider(provider: .theGuardian)
                provider(provider: .reuters)
                provider(provider: .derSpiegel)
                provider(provider: .theLocal)
            }
        }
        .listStyle(.plain)
        .navigationTitle("Feeds")
        .navigationBarTitleDisplayMode(.large)
        .background(session.reader ? .init("Background") : Color.clear)
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
            NavigationLink(tag: provider, selection: $session.provider) {
                Middlebar(session: session)
            } label: {
                HStack(spacing: 0) {
                    Text(verbatim: provider.title)
                        .foregroundColor(session.reader ? .accentColor : .primary)
                        .font(.body.weight(.medium))
                    Spacer()
                    if recents[provider]! > 0 {
                        ZStack {
                            Capsule()
                                .fill(Color.accentColor)
                            Text(recents[provider]!, format: .number)
                                .font(.footnote.monospacedDigit().weight(.bold))
                                .foregroundColor(session.reader ? .init("Background") : .white)
                                .padding(.horizontal, 11)
                                .padding(.vertical, 5)
                        }
                        .fixedSize()
                    }
                }
                .padding(.vertical, 15)
                .contentShape(Rectangle())
            }
            .listRowBackground(session.reader
                               ? session.provider == provider
                                    ? .accentColor.opacity(0.15)
                                    : Color.clear
                               : nil)
        }
    }
}
