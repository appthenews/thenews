import Foundation
import Archivable

public struct Item: Storable, Hashable {
    public let title: String
    public let date: Date
    
    public var data: Data {
        .init()
    }
    
    public init(data: inout Data) {
        title = ""
        date = .now
    }
    
    init(title: String, date: Date) {
        self.title = title
        self.date = date
    }
}
