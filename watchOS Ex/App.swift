import SwiftUI
import News

@main struct App: SwiftUI.App {
    @StateObject private var session = Session()
    @State private var feeds = false
    @State private var selection = Int()
    @Environment(\.scenePhase) private var phase
    @WKExtensionDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selection) {
                NavigationView {
                    Sidebar(session: session)
                }
                
                Circle()
            }
            .sheet(isPresented: $feeds) {
                Feeds(session: session)
            }
            .task {
                delegate.session = session
                
                session.cloud.ready.notify(queue: .main) {
                    session.cloud.pull.send()
                    
                    if session.loading {
                        session.loading = false
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            Task {
                                if await session.cloud.model.preferences.providers.isEmpty {
                                    feeds = true
                                }
                                
                                await session.cloud.fetch()
                            }
                        }
                    }
                    
                    Defaults.start()
                }
            }
        }
        .onChange(of: phase) {
            switch $0 {
            case .active:
                session.cloud.pull.send()
                
                if !session.loading {
                    Task {
                        await session.cloud.fetch()
                    }
                }
            default:
                break
            }
        }
    }
}
