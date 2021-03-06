import Foundation
import Archivable

public struct Item: Storable, Hashable, Comparable {
    public let feed: Feed
    public let title: String
    public let description: String
    public let link: String
    public let date: Date
    public let status: Status
    let synched: Date
    
    public var recent: Bool {
        status == .new && !Interval.hour.passed(date: synched)
    }
    
    public var data: Data {
        .init()
        .adding(feed.rawValue)
        .adding(size: UInt8.self, string: title)
        .adding(size: UInt16.self, string: description)
        .adding(size: UInt8.self, string: link)
        .adding(date)
        .adding(synched)
        .adding(status.rawValue)
    }
    
    public init(data: inout Data) {
        feed = .init(rawValue: data.number())!
        title = data.string(size: UInt8.self)
        description = data.string(size: UInt16.self)
        link = data.string(size: UInt8.self)
        date = data.date()
        synched = data.date()
        status = .init(rawValue: data.number())!
    }
    
    init(feed: Feed,
         title: String,
         description: String,
         link: String,
         date: Date,
         synched: Date,
         status: Status) {
        
        self.feed = feed
        self.title = title
        self.description = description
        self.link = link
        self.date = date
        self.synched = synched
        self.status = status
    }
    
    var read: Self {
        .init(feed: feed,
              title: title,
              description: description,
              link: link,
              date: date,
              synched: synched,
              status: .read)
    }
    
    var bookmarked: Self {
        .init(feed: feed,
              title: title,
              description: description,
              link: link,
              date: date,
              synched: synched,
              status: .bookmarked)
    }
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.date == rhs.date
        ? lhs.title.localizedCaseInsensitiveCompare(rhs.title) == .orderedAscending
        : lhs.date > rhs.date
    }
}
