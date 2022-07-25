import Foundation
import Archivable

public struct Archive: Arch {
    public var timestamp: UInt32
    public internal(set) var preferences: Preferences
    private(set) var feeds: [Feed : Date]
    private(set) var ids: Set<String>
    var items: Set<Item>
    var history: [String]
    
    public var recents: [Item] {
        history
            .compactMap { recent in
                items
                    .first {
                        $0.link == recent
                    }
            }
    }

    public var data: Data {
        .init()
        .adding(preferences)
        .adding(UInt8(feeds.count))
        .adding(feeds.reduce(.init()) {
            $0
                .adding($1.key.rawValue)
                .adding($1.value)
        })
        .adding(collection: UInt32.self, strings: UInt8.self, items: ids)
        .adding(size: UInt16.self, collection: items)
        .adding(collection: UInt8.self, strings: UInt8.self, items: history)
    }
    
    var fetchable: Set<Feed> {
        .init(preferences
            .feeds
            .filter {
                $0.value
            }
            .filter {
                feeds[$0.key]
                    .map {
                        preferences.fetch.passed(date: $0)
                    }
                ?? false
            }
            .map {
                $0.key
            })
    }
    
    public init() {
        timestamp = 0
        preferences = .init()
        feeds = Feed.synch
        ids = []
        items = []
        history = []
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        var data = data
        self.timestamp = timestamp
        
        if version == Self.version {
            preferences = .init(data: &data)
            feeds = (0 ..< .init(data.number() as UInt8)).reduce(into: [:]) { result, _ in
                result[.init(rawValue: data.number())!] = data.date()
            }
            ids = .init(data.items(collection: UInt32.self, strings: UInt8.self))
            items = .init(data.collection(size: UInt16.self))
            history = .init(data.items(collection: UInt8.self, strings: UInt8.self))
        } else {
            preferences = .init()
            feeds = Feed.synch
            ids = []
            items = []
            history = []
        }
    }
    
    public func items(provider: Provider) -> [Item] {
        items
            .filter {
                preferences.feeds[$0.feed]!
                && (provider == .all || provider == $0.feed.provider)
            }
    }
    
    mutating func clean() {
        items = items
            .filter {
                $0.status == .bookmarked || !preferences.clean.passed(date: $0.synched)
            }
    }
    
    mutating func update(feed: Feed, date: Date, ids: Set<String>, items: Set<Item>) {
        feeds[feed] = date
        self.ids = self.ids.union(ids)
        self.items = self.items.union(items)
    }
}
