import SwiftUI

struct Feeds: View {
    @ObservedObject var session: Session
    @State private var theGuardianWorld = false
    
    var body: some View {
        List {
            Section("The Guardian") {
                Toggle("World", isOn: $theGuardianWorld)
                Toggle("Germany", isOn: $theGuardianWorld)
            }
            .headerProminence(.increased)
            
            Section("Reuters") {
                Toggle("International", isOn: $theGuardianWorld)
                Toggle("Europe", isOn: $theGuardianWorld)
            }
            .headerProminence(.increased)
            
            Section("Der Spiegel") {
                Toggle("International", isOn: $theGuardianWorld)
            }
            .headerProminence(.increased)

            Section("The Local") {
                Toggle("International", isOn: $theGuardianWorld)
                Toggle("Germany", isOn: $theGuardianWorld)
            }
            .headerProminence(.increased)
        }
        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
        .listStyle(.insetGrouped)
        .navigationTitle("Feeds")
        .navigationBarTitleDisplayMode(.large)
    }
}
