import SwiftUI
import News

extension Settings {
    struct Update: View {
        let session: Session
        @State private var fetch = Interval.hour
        @State private var clean = Interval.hour
        
        var body: some View {
            List {
                Section("Update every") {
                    Picker("Update every interval", selection: $fetch) {
                        ForEach([Interval.hour, .hours3, .hours6, .day], id: \.self) {
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
                    Picker("Delete after interval", selection: $clean) {
                        ForEach([Interval.hours6, .day, .days3, .week], id: \.self) {
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
            .navigationTitle("Update")
            .navigationBarTitleDisplayMode(.large)
            .onReceive(session.cloud) {
                fetch = $0.preferences.fetch
                clean = $0.preferences.clean
            }
        }
    }
}
