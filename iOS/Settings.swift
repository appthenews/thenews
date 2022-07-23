import SwiftUI

struct Settings: View {
    @ObservedObject var session: Session
    
    var body: some View {
        List {
            
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}
