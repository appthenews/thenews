import SwiftUI

extension Settings {
    struct Reading: View {
        @ObservedObject var session: Session
        
        var body: some View {
            List {
                Section(footer: Text("Makes reading easy on the eyes").font(.callout)) {
                    Toggle("Reader", isOn: $session.reader)
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Reading")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
