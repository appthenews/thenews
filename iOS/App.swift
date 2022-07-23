import SwiftUI
import News

@main struct App: SwiftUI.App {
    @State private var selection = 1
    @Environment(\.scenePhase) private var phase
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selection) {
                NavigationView {
                    Settings(session: delegate.session)
                }
                .navigationViewStyle(.stack)
                .tabItem {
                    Label("Settings", systemImage: "slider.horizontal.3")
                }
                .tag(0)
                NavigationView {
                    Sidebar(session: delegate.session)
                    Middlebar(session: delegate.session)
                    Content(session: delegate.session)
                }
                .navigationViewStyle(.columns)
                .tabItem {
                    Label("News", image: "Icon")
                }
                .tag(1)
                NavigationView {
                    Recent(session: delegate.session)
                    Content(session: delegate.session)
                }
                .navigationViewStyle(.columns)
                .tabItem {
                    Label("Recent", systemImage: "clock")
                }
                .tag(2)
            }
            .task {
                delegate.session.cloud.ready.notify(queue: .main) {
                    delegate.session.cloud.pull.send()
                    Defaults.start()
                    
                    Task
                        .detached {
                            await delegate.session.store.launch()
                        }
                }
            }
        }
        .onChange(of: phase) {
            switch $0 {
            case .active:
                delegate.session.cloud.pull.send()
                
                Task {
                    await delegate.session.cloud.fetch()
//                    session.notify()
                }
            default:
                break
            }
        }
    }
}
