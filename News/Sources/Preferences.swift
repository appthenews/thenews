import Foundation
import Archivable

public struct Preferences: Storable {
    public internal(set) var feeds: [Feed : Bool]
    public internal(set) var fetch: Interval
    public internal(set) var clean: Interval
    
    public var providers: Set<Provider> {
        .init(feeds
            .filter {
                $0.value
            }
            .map(\.key.provider))
    }
    
    public var data: Data {
        .init()
        .adding(UInt8(feeds.count))
        .adding(feeds.reduce(.init()) {
            $0
                .adding($1.key.rawValue)
                .adding($1.value)
        })
        .adding(fetch.rawValue)
        .adding(clean.rawValue)
    }
    
    public init(data: inout Data) {
        feeds = (0 ..< .init(data.number() as UInt8)).reduce(into: [:]) { result, _ in
            result[.init(rawValue: data.number())!] = data.bool()
        }
        fetch = .init(rawValue: data.number())!
        clean = .init(rawValue: data.number())!
    }
    
    init() {
        feeds = Feed.allCases.reduce(into: [:]) {
            $0[$1] = false
        }
        fetch = .day
        clean = .day
    }
}
