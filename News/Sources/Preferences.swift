import Foundation
import Archivable

public struct Preferences: Storable {
    public internal(set) var theguardian_world: Bool
    public internal(set) var theguardian_germany: Bool
    public internal(set) var reuters_international: Bool
    public internal(set) var reuters_europe: Bool
    public internal(set) var derspiegel_international: Bool
    public internal(set) var thelocal_international: Bool
    public internal(set) var thelocal_germany: Bool
    
    public var data: Data {
        .init()
    }
    
    public init(data: inout Data) {
        
    }
    
    init() {
        theguardian_world = false
        theguardian_germany = false
        reuters_international = false
        reuters_europe = false
        derspiegel_international = false
        thelocal_international = false
        thelocal_germany = false
    }
}
