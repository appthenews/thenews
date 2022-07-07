import Foundation
import Archivable

public struct Preferences: Storable {
    public internal(set) var sources: [Source : Bool]
    public internal(set) var fetch: Interval
    public internal(set) var delete: Interval
    
    public var providers: Set<Provider> {
        .init(sources
            .filter {
                $0.value
            }
            .map(\.key.provider))
    }
    
    public var data: Data {
        .init()
        .adding(UInt8(sources.count))
        .adding(sources.reduce(.init()) {
            $0
                .adding($1.key.rawValue)
                .adding($1.value)
        })
        .adding(fetch.rawValue)
        .adding(delete.rawValue)
    }
    
    public init(data: inout Data) {
        sources = (0 ..< .init(data.number() as UInt8)).reduce(into: [:]) { result, _ in
            result[.init(rawValue: data.number())!] = data.bool()
        }
        fetch = .init(rawValue: data.number())!
        delete = .init(rawValue: data.number())!
    }
    
    init() {
        sources = Source.allCases.reduce(into: [:]) {
            $0[$1] = false
        }
        fetch = .day
        delete = .day
    }
}
