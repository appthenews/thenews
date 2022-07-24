import SwiftUI
import News

struct Feeds: View {
    @ObservedObject var session: Session
    @State private var theGuardianWorld = false
    
    var body: some View {
        List {
            Section(Provider.theGuardian.title) {
                Toggle("World", isOn: $theGuardianWorld)
                Toggle("Germany", isOn: $theGuardianWorld)
            }
            .headerProminence(.increased)
            
            Section(Provider.reuters.title) {
                Toggle("International", isOn: $theGuardianWorld)
                Toggle("Europe", isOn: $theGuardianWorld)
            }
            .headerProminence(.increased)
            
            Section(Provider.derSpiegel.title) {
                Toggle("International", isOn: $theGuardianWorld)
            }
            .headerProminence(.increased)

            Section(Provider.theLocal.title) {
                Toggle("International", isOn: $theGuardianWorld)
                Toggle("Germany", isOn: $theGuardianWorld)
            }
            .headerProminence(.increased)
        }
        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
        .listStyle(.insetGrouped)
        .navigationBarTitleDisplayMode(.large)
    }
}
