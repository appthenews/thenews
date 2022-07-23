import SwiftUI

struct Feeds: View {
    @ObservedObject var session: Session
    
    var body: some View {
        List {
            
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Feeds")
        .navigationBarTitleDisplayMode(.large)
    }
}
