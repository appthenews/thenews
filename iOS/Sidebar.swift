import SwiftUI

struct Sidebar: View {
    @ObservedObject var session: Session
    
    var body: some View {
        List {
            
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Feeds")
        .navigationBarTitleDisplayMode(.large)
    }
}
