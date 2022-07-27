import SwiftUI
import News

@main struct App: SwiftUI.App {
    @StateObject private var session = Session()
    @State private var purchased = false
    @Environment(\.scenePhase) private var phase
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $session.tab) {
                settings
                    .navigationViewStyle(.stack)
                if UIDevice.current.userInterfaceIdiom == .pad {
                    news
                        .navigationViewStyle(.columns)
                } else {
                    news
                        .navigationViewStyle(.stack)
                }
                recents
                    .navigationViewStyle(.stack)
            }
            .sheet(isPresented: $purchased) {
                Sheet(rootView: Purchased())
            }
            .accentColor(session.reader ? .init("Text") : .init("AccentColor"))
            .onReceive(session.store.purchased) {
                session.froob = false
                purchased = true
            }
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
            Middlebar(session: session)
            Content(session: session)
        }
        .tabItem {
            Label("News", image: "Icon")
        }
        .tag(1)
    }
    
    private var recents: some View {
        NavigationView {
            Recents(session: session)
        }
        .tabItem {
            Label("Recents", systemImage: "clock.arrow.circlepath")
        }
        .tag(2)
    }
}
