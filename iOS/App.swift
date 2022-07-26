import SwiftUI
import News

@main struct App: SwiftUI.App {
    @StateObject private var session = Session()
    @State private var selection = 1
    @Environment(\.scenePhase) private var phase
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    
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
            .accentColor(session.reader ? .init("Text") : .init("AccentColor"))
            .task {
                delegate.session = session
                session.cloud.ready.notify(queue: .main) {
                    session.cloud.pull.send()
                    Defaults.start()
                    
                    Task
                        .detached {
                            await session.store.launch()
                        }
                }
            }
        }
        .onChange(of: phase) {
            switch $0 {
            case .active:
                session.cloud.pull.send()
                
                Task {
                    await session.cloud.fetch()
                }
            default:
                break
            }
        }
    }
    
    private var settings: some View {
        NavigationView {
            Settings(session: session)
        }
        .tabItem {
            Label("Settings", systemImage: "slider.horizontal.3")
        }
        .tag(0)
    }
    
    private var news: some View {
        NavigationView {
            Sidebar(session: session)
            Middlebar(session: session, provider: nil)
            Content(session: session, link: nil, provider: nil)
        }
        .tabItem {
            Label("News", image: "Icon")
        }
        .tag(1)
    }
    
    private var recent: some View {
        NavigationView {
            Recent(session: session)
            Content(session: session, link: nil, provider: nil)
        }
        .tabItem {
            Label("Recent", systemImage: "clock")
        }
        .tag(2)
    }
}
