import SwiftUI

extension Settings {
    struct Reading: View {
        @ObservedObject var session: Session
        
        var body: some View {
            List {
                Section("Font size") {
                    Slider(value: $session.font, in: -2 ... 14, step: 2) {
                        Text("Font size")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    } minimumValueLabel: {
                        Text(verbatim: "A")
                            .font(.system(size: UIFont.preferredFont(forTextStyle: .body).pointSize - 2, weight: .medium))
                            .foregroundStyle(.secondary)
                    } maximumValueLabel: {
                        Text(verbatim: "A")
                            .font(.system(size: UIFont.preferredFont(forTextStyle: .body).pointSize + 14, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                    .listRowBackground(Color.clear)
                }
                .textCase(.none)
                .headerProminence(.increased)
            }
            .navigationTitle("Reading")
        }
    }
}
