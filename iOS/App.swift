import SwiftUI
import News

@main struct App: SwiftUI.App {
    @State private var selection = 1
    @Environment(\.scenePhase) private var phase
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    @AppStorage("reader") private var reader = false
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selection) {
                settings
                    .navigationViewStyle(.stack)
                if UIDevice.current.userInterfaceIdiom == .pad {
                    news
                        .navigationViewStyle(.columns)
                    recent
                        .navigationViewStyle(.columns)
                } else {
                    news
                        .navigationViewStyle(.stack)
                    recent
                        .navigationViewStyle(.stack)
                }
            }
            .tint(reader ? Color("Text") : .accentColor)
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
    
    private var settings: some View {
        NavigationView {
            Settings(session: delegate.session)
        }
        .tabItem {
            Label("Settings", systemImage: "slider.horizontal.3")
        }
        .tag(0)
    }
    
    private var news: some View {
        NavigationView {
            Sidebar(session: delegate.session)
            Middlebar(session: delegate.session, provider: nil)
            Content(session: delegate.session, link: nil, provider: nil)
        }
        .tabItem {
            Label("News", image: "Icon")
        }
        .tag(1)
    }
    
    private var recent: some View {
        NavigationView {
            Recent(session: delegate.session)
            Content(session: delegate.session, link: nil, provider: nil)
        }
        .tabItem {
            Label("Recent", systemImage: "clock")
        }
        .tag(2)
    }
}
