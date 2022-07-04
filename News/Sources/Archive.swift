import Foundation
import Archivable

public struct Archive: Arch {
    public var timestamp: UInt32

    public var data: Data {
        .init()
    }
    
    public init() {
        timestamp = 0
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        var data = data
        self.timestamp = timestamp
        
        if version == Self.version {
//            projects = data.collection(size: UInt8.self)
//            settings = .init(data: &data)
        } else {
            
        }
    }
}
