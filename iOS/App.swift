import SwiftUI
import News

@main struct App: SwiftUI.App {
    @StateObject private var session = Session()
    @State private var purchased = false
    @State private var feeds = false
    @Environment(\.scenePhase) private var phase
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $session.tab) {
                settings
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    NavigationView {
                        Sidebar(session: session)
                        Middlebar(session: session)
                        Content(session: session)
                    }
                    .navigationViewStyle(.columns)
                    .tabItem {
                        Label("News", image: "Icon")
                    }
                    .tag(1)
                } else {
                    NavigationView {
                        Sidebar(session: session)
                    }
                    .navigationViewStyle(.stack)
                    .tabItem {
                        Label("News", image: "Icon")
                    }
                    .tag(1)
                }
                
                recents
                    
            }
            .sheet(isPresented: $purchased) {
                Sheet(rootView: Purchased())
            }
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
            .accentColor(session.reader ? .init("Text") : .init("AccentColor"))
            .onReceive(session.store.purchased) {
                session.froob = false
                purchased = true
            }
            .task {
                delegate.session = session
                session.cloud.ready.notify(queue: .main) {
                    if session.loading {
                        session.loading = false
                        
                        if UIDevice.current.userInterfaceIdiom == .pad  {
                            session.provider = .all
                        }
                        
                        Task {
                            if await session.cloud.model.preferences.providers.isEmpty {
                                feeds = true
                            }
                            
                            await session.cloud.fetch()
                        }
                    }
                    
                    Defaults.start()
                }
                
                Task
                    .detached {
                        await session.store.launch()
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
    
    private var settings: some View {
        NavigationView {
            Settings(session: session)
        }
        .navigationViewStyle(.stack)
        .tabItem {
            Label("Settings", systemImage: "slider.horizontal.3")
        }
        .tag(0)
    }
    
    private var recents: some View {
        NavigationView {
            Recents(session: session)
        }
        .navigationViewStyle(.stack)
        .tabItem {
            Label("Recents", systemImage: "clock.arrow.circlepath")
        }
        .tag(2)
    }
}
