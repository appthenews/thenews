import SwiftUI

struct Settings: View {
    let session: Session
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Filters", destination: Filters(session: session))
                    .font(.callout)
                
                NavigationLink("Feeds", destination: Feeds(session: session, dismissable: false))
                    .font(.callout)
                
                NavigationLink("Refresh", destination: Update(session: session))
                    .font(.callout)
                
                NavigationLink("Reading", destination: Reading(session: session))
                    .font(.callout)
            }
            .navigationTitle("Settings")
        }
    }
}
