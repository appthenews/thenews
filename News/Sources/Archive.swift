import Foundation
import Archivable

public struct Archive: Arch {
    public var timestamp: UInt32
    public internal(set) var preferences: Preferences
    var history: [Source : History]

    public var data: Data {
        .init()
        .adding(preferences)
        .adding(UInt8(history.count))
        .adding(history.reduce(.init()) {
            $0
                .adding($1.key.rawValue)
                .adding($1.value)
        })
    }
    
    var fetchable: Set<Source> {
        .init(preferences
            .sources
            .filter {
                $0.value
            }
            .filter {
                history[$0.key]
                    .map {
                        preferences.fetch.passed(date: $0.synched)
                    }
                ?? false
            }
            .map {
                $0.key
            })
    }
    
    public init() {
        timestamp = 0
        preferences = .init()
        history = Source.allCases.reduce(into: [:]) {
            $0[$1] = .init()
        }
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        var data = data
        self.timestamp = timestamp
        
        if version == Self.version {
            preferences = .init(data: &data)
            history = (0 ..< .init(data.number() as UInt8)).reduce(into: [:]) { result, _ in
                result[.init(rawValue: data.number())!] = .init(data: &data)
            }
        } else {
            preferences = .init()
            history = [:]
        }
    }
    
    public func items(source: Source?) -> [(source: Source, item: Item)] {
        (source == nil
         ? history
            .flatMap { source, history in
                history
                    .items
                    .map {
                        (source: source, item: $0)
                    }
            }
         : history[source!]!
            .items
            .map {
                (source: source!, item: $0)
            })
        .sorted { left, right in
            left.item.date >= right.item.date
        }
    }
}
