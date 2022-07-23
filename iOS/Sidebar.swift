import SwiftUI
import News

struct Sidebar: View {
    @ObservedObject var session: Session
    @State private var providers = Set<Provider>()
    @State private var feeds = false
    
    var body: some View {
        List {
            
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Feeds")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $feeds) {
            NavigationView {
                Feeds(session: session)
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
}
