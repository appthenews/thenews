import SwiftUI

@main struct App: SwiftUI.App {
    @StateObject private var session = Session()
    @State private var selection = 1
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selection) {
                NavigationView {
                    Settings(session: session)
                    Rectangle()
                }
                .navigationViewStyle(.columns)
                .tabItem {
                    Label("Settings", systemImage: "slider.horizontal.3")
                }
                .tag(0)
                NavigationView {
                    Feeds(session: session)
                    Articles(session: session)
                    Article(session: session)
                }
                .navigationViewStyle(.columns)
                .tabItem {
                    Label("News", image: "Icon")
                }
                .tag(1)
                NavigationView {
                    Recent(session: session)
                    Article(session: session)
                }
                .navigationViewStyle(.columns)
                .tabItem {
                    Label("Recent", systemImage: "clock")
                }
                .tag(2)
            }
        }
    }
}
