import SwiftUI

struct Settings: View {
    let session: Session
    
    var body: some View {
        List {
            purchases
            preferences
            app
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private var purchases: some View {
        Section("In-App Purchases") {
            NavigationLink("Sponsor", destination: Circle())
                .font(.callout)
        }
        .headerProminence(.increased)
    }
    
    private var preferences: some View {
        Section("Preferences") {
            NavigationLink("Feeds", destination: Feeds(session: session)
                .navigationTitle("Feeds"))
                .font(.callout)
            
            NavigationLink("Update", destination: Update(session: session))
                .font(.callout)
            
            NavigationLink("Reading", destination: Reading(session: session))
                .font(.callout)
        }
        .headerProminence(.increased)
    }
    
    private var app: some View {
        Section("The News") {
            NavigationLink("About", destination: Circle())
                .font(.callout)
            
            Button {
                UIApplication.shared.review()
            } label: {
                HStack {
                    Text("Rate on the App Store")
                        .font(.callout)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "star")
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.accentColor)
                        .frame(width: 24)
                }
            }
            
            Link(destination: .init(string: "https://appthenews.github.io/about")!) {
                HStack {
                    Text("appthenews.github.io/about")
                        .foregroundColor(.primary)
                        .font(.footnote.weight(.regular))
                    
                    Spacer()
                    Image(systemName: "link")
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.accentColor)
                        .frame(width: 24)
                }
            }
        }
        .headerProminence(.increased)
    }
}
