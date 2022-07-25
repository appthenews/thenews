import SwiftUI

extension Settings {
    struct Reading: View {
        @AppStorage("reader") private var reader = false
        
        var body: some View {
            List {
                Section(footer: Text("Makes reading easy on the eyes").font(.callout)) {
                    Toggle("Reader", isOn: $reader)
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Reading")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
