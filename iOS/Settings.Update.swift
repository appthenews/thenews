import SwiftUI
import News

extension Settings {
    struct Update: View {
        let session: Session
        @State private var fetch = Interval.hour
        @State private var clean = Interval.hour
        
        var body: some View {
            List {
                Section("Refresh every") {
                    Picker("Refresh every", selection: $fetch) {
                        ForEach([Interval.hour, .hours3, .hours6, .hours12], id: \.self) {
                            Text(verbatim: $0.title)
                                .tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .onChange(of: fetch) { interval in
                        Task {
                            await session.cloud.fetch(interval: interval)
                        }
                    }
                }
                .headerProminence(.increased)
                
                Section("Delete after") {
                    Picker("Delete after", selection: $clean) {
                        ForEach([Interval.hours12, .day, .days3, .week], id: \.self) {
                            Text(verbatim: $0.title)
                                .tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .onChange(of: clean) { interval in
                        Task {
                            await session.cloud.clean(interval: interval)
                        }
                    }
                }
                .headerProminence(.increased)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Refresh")
            .navigationBarTitleDisplayMode(.large)
            .onReceive(session.cloud) {
                fetch = $0.preferences.fetch
                clean = $0.preferences.clean
            }
        }
    }
}
