import SwiftUI

extension Settings {
    struct Filters: View {
        @ObservedObject var session: Session
        
        var body: some View {
            Picker("Showing", selection: $session.showing) {
                Text(verbatim: "All")
                    .tag(0)
                Text(verbatim: "Not read")
                    .tag(1)
                Text(verbatim: "Bookmarks")
                    .tag(2)
            }
            .pickerStyle(.inline)
            .navigationTitle("Filters")
        }
    }
}
