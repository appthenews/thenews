import Foundation
import Archivable

public struct Archive: Arch {
    public var timestamp: UInt32
    public internal(set) var preferences: Preferences

    public var data: Data {
        .init()
        .adding(preferences)
    }
    
    public init() {
        timestamp = 0
        preferences = .init()
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        var data = data
        self.timestamp = timestamp
        
        if version == Self.version {
            preferences = .init(data: &data)
        } else {
            preferences = .init()
        }
    }
}
