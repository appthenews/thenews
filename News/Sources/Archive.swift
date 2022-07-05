import Foundation
import Archivable

public struct Archive: Arch {
    public var timestamp: UInt32
    public internal(set) var preferences: Preferences
    public internal(set) var synched: [Source : Date]

    public var data: Data {
        .init()
        .adding(preferences)
        .adding(UInt8(synched.count))
        .adding(synched.reduce(.init()) {
            $0
                .adding($1.key.rawValue)
                .adding($1.value)
        })
    }
    
    public init() {
        timestamp = 0
        preferences = .init()
        synched = Source.allCases.reduce(into: [:]) {
            $0[$1] = .init(timeIntervalSince1970: 0)
        }
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        var data = data
        self.timestamp = timestamp
        
        if version == Self.version {
            preferences = .init(data: &data)
            synched = (0 ..< .init(data.number() as UInt8)).reduce(into: [:]) { result, _ in
                result[.init(rawValue: data.number())!] = data.date()
            }
        } else {
            preferences = .init()
            synched = [:]
        }
    }
}
