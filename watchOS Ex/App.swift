import SwiftUI
import News

@main struct App: SwiftUI.App {
    @StateObject private var session = Session()
    @State private var feeds = false
    @State private var selection = Int()
    @Environment(\.scenePhase) private var phase
    @WKApplicationDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selection) {
                Sidebar(session: session)
                Settings(session: session)
            }
            .sheet(isPresented: $feeds) {
                Feeds(session: session, dismissable: true)
            }
            .task {
                delegate.session = session
                
                session.cloud.ready.notify(queue: .main) {
                    if session.loading {
                        session.loading = false
                        
                        Task {
                            if await session.cloud.model.preferences.providers.isEmpty {
                                feeds = true
                            }
                            
                            await session.cloud.fetch()
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
