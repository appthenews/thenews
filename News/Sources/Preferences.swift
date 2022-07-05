import Foundation
import Archivable

public struct Preferences: Storable {
    public internal(set) var sources: [Source : Bool]
    
    public var data: Data {
        .init()
    }
    
    public init(data: inout Data) {
        sources = [:]
    }
    
    init() {
        sources = Source.allCases.reduce(into: [:]) {
            $0[$1] = false
        }
    }
}
