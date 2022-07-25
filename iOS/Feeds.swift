import SwiftUI
import News

struct Feeds: View {
    let session: Session
    @State private var feeds = Feed.allCases.map { _ in false }
    
    var body: some View {
        List {
            Section(Provider.theGuardian.title) {
                feed(feed: .theGuardianWorld)
                feed(feed: .theGuardianGermany)
            }
            .headerProminence(.increased)
            
            Section(Provider.reuters.title) {
                feed(feed: .reutersInternational)
                feed(feed: .reutersEurope)
            }
            .headerProminence(.increased)
            
            Section(Provider.derSpiegel.title) {
                feed(feed: .derSpiegelInternational)
            }
            .headerProminence(.increased)

            Section(Provider.theLocal.title) {
                feed(feed: .theLocalInternational)
                feed(feed: .theLocalGermany)
            }
            .headerProminence(.increased)
        }
        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
        .listStyle(.insetGrouped)
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func feed(feed: Feed) -> some View {
        Toggle(feed.title, isOn: $feeds[.init(feed.rawValue)])
            .onChange(of: feeds[.init(feed.rawValue)]) { newValue in
                Task {
                    await session.cloud.toggle(feed: feed, value: newValue)
                }
            }
    }
}
