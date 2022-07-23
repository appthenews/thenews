import SwiftUI

@main struct iOSApp: SwiftUI.App {
    @StateObject private var session = Session()
    @State private var selection = 1
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selection) {
                NavigationView {
                    Circle()
                    Rectangle()
                }
                .navigationViewStyle(.columns)
                .tabItem {
                    Label("Settings", systemImage: "slider.horizontal.3")
                        .symbolRenderingMode(.hierarchical)
                }
                .tag(0)
                NavigationView {
                    Circle()
                    Rectangle()
                    Circle()
                }
                .navigationViewStyle(.columns)
                .tabItem {
                    Label("News", systemImage: "newspaper")
                        .symbolRenderingMode(.hierarchical)
                }
                .tag(1)
                NavigationView {
                    Circle()
                    Rectangle()
                }
                .navigationViewStyle(.columns)
                .tabItem {
                    Label("Recent", systemImage: "clock")
                        .symbolRenderingMode(.hierarchical)
                }
                .tag(2)
            }
        }
    }
}
