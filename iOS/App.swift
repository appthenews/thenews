import SwiftUI

@main struct iOSApp: SwiftUI.App {
    @StateObject private var session = Session()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Circle()
                Rectangle()
                Circle()
            }
            .navigationViewStyle(.columns)
        }
    }
}
