import SwiftUI
import News

struct Sidebar: View {
    @ObservedObject var session: Session
    @State private var providers = Set<Provider>()
    @State private var feeds = false
    
    var body: some View {
        List {
            provider(provider: .all)
            provider(provider: .theGuardian)
            NavigationLink(Provider.reuters.title, destination: Circle())
            NavigationLink(Provider.derSpiegel.title, destination: Circle())
            NavigationLink(Provider.theLocal.title, destination: Circle())
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Feeds")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $feeds) {
            NavigationView {
                Feeds(session: session)
                    .navigationTitle("Select your Feeds")
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
        .onReceive(session.cloud) {
            providers = $0.preferences.providers
            
            if providers.isEmpty {
                feeds = true
            }
        }
    }
    
    private func provider(provider: Provider) -> some View {
        NavigationLink(destination: Circle()) {
            HStack(spacing: 0) {
                Text(provider.title)
                    .font(.body.weight(.medium))
                Spacer()
                ZStack {
                    Capsule()
                        .fill(Color.accentColor)
                    Text("34")
                        .font(.footnote.weight(.medium))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                }
                .fixedSize()
            }
            .padding(.vertical, 8)
        }
    }
}
