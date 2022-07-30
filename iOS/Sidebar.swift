import SwiftUI
import News

struct Sidebar: View {
    @ObservedObject var session: Session
    @State private var providers = Set<Provider>()
    @State private var recents = Provider.allCases.reduce(into: [:]) { $0[$1] = 0 }
    @State private var selection: Provider?
    
    var body: some View {
        List {
            if session.loading {
                if UIDevice.current.userInterfaceIdiom == .phone  {
                    Loading()
                }
            } else {
                provider(provider: .all)
                provider(provider: .theGuardian)
                provider(provider: .reuters)
                provider(provider: .derSpiegel)
                provider(provider: .theLocal)
            }
        }
        .listStyle(.plain)
        .navigationTitle(session.loading ? "" : "Feeds")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: Middlebar(session: session), tag: true, selection: .init(get: {
                    session.provider != nil
                }, set: {
                    if $0 != true {
                        session.provider = nil
                    }
                })) { }
            }
        }
        .background(session.reader ? .init("Background") : Color.clear)
        .onReceive(session.cloud) { model in
            providers = model.preferences.providers
            recents = Provider
                .allCases
                .reduce(into: [:]) { result, provider in
                    if provider == .all || providers.contains(provider) {
                        result[provider] = model
                            .items(provider: provider)
                            .filter(\.recent)
                            .count
                    } else {
                        result[provider] = 0
                    }
                }
        }
    }
    
    @ViewBuilder private func provider(provider: Provider) -> some View {
        if provider == .all || providers.contains(provider) {
            Button {
                session.provider = provider
            } label: {
                HStack(spacing: 0) {
                    Text(verbatim: provider.title)
                        .foregroundColor(session.reader ? .accentColor : .primary)
                        .font(.body.weight(.medium))
                    Spacer()
                    if recents[provider]! > 0 {
                        ZStack {
                            Capsule()
                                .fill(Color.accentColor)
                            Text(recents[provider]!, format: .number)
                                .font(.footnote.monospacedDigit().weight(.bold))
                                .foregroundColor(session.reader ? .init("Background") : .white)
                                .padding(.horizontal, 11)
                                .padding(.vertical, 5)
                        }
                        .fixedSize()
                    }
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.init(.tertiaryLabel))
                        .frame(width: 16)
                        .padding(.leading)
                }
                .padding(.vertical, 8)
                .contentShape(Rectangle())
            }
            .buttonStyle(Listed {
                if $0 {
                    selection = provider
                } else if selection == provider {
                    selection = nil
                }
            })
            .listRowBackground(session.provider == provider || selection == provider
                               ? .accentColor.opacity(0.15)
                               : Color.clear)
        }
    }
}
