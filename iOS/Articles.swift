import SwiftUI

struct Articles: View {
    @ObservedObject var session: Session
    
    var body: some View {
        List {
            
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Articles")
        .navigationBarTitleDisplayMode(.large)
    }
}
