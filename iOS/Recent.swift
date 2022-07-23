import SwiftUI

struct Recent: View {
    @ObservedObject var session: Session
    
    var body: some View {
        List {
            
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Recent")
        .navigationBarTitleDisplayMode(.large)
    }
}
