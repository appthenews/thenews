import Foundation
import Archivable

public struct Preferences: Storable {
    public internal(set) var sources: [Source : Bool]
    public internal(set) var fetch: Interval
    public internal(set) var delete: Interval
    
    public var data: Data {
        .init()
    }
    
    public init(data: inout Data) {
        sources = [:]
        fetch = .hours3
        delete = .hours3
    }
    
    init() {
        sources = Source.allCases.reduce(into: [:]) {
            $0[$1] = false
        }
        fetch = .day
        delete = .day
    }
}
