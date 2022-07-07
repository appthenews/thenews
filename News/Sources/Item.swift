import Foundation
import Archivable

public struct Item: Storable, Hashable {
    public let title: String
    public let description: String
    public let link: String
    public let date: Date
    
    public var data: Data {
        .init()
        .adding(size: UInt8.self, string: title)
        .adding(size: UInt16.self, string: description)
        .adding(size: UInt8.self, string: link)
        .adding(date)
    }
    
    public init(data: inout Data) {
        title = data.string(size: UInt8.self)
        description = data.string(size: UInt16.self)
        link = data.string(size: UInt8.self)
        date = data.date()
    }
    
    init(title: String,
         description: String,
         link: String,
         date: Date) {
        self.title = title
        self.description = description
        self.link = link
        self.date = date
    }
}
