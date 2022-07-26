import SwiftUI

extension Settings {
    struct Reading: View {
        @ObservedObject var session: Session
        
        var body: some View {
            List {
                Section(header: Text("Make reading easy on the eyes").font(.callout)) {
                    Toggle("Reader", isOn: $session.reader)
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                }
                .textCase(.none)
                
                Section {
                    
                }
                
                Section("Font size") {
                    Slider(value: $session.font, in: -2 ... 10, step: 2) {
                        Text("Font size")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    } minimumValueLabel: {
                        Text("A")
                            .font(.system(size: UIFont.preferredFont(forTextStyle: .body).pointSize, weight: .medium))
                            .foregroundStyle(.secondary)
                    } maximumValueLabel: {
                        Text("A")
                            .font(.system(size: UIFont.preferredFont(forTextStyle: .body).pointSize + 10, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                    .listRowBackground(Color.clear)
                }
                .textCase(.none)
                .headerProminence(.increased)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Reading")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
