import XCTest
@testable import Archivable
@testable import News

final class CloudTests: XCTestCase {
    private var cloud: Cloud<Archive, MockContainer>!
    
    override func setUp() {
        cloud = .init()
    }
    
    func testRead() async {
        let item = Item(feed: .reutersInternational,
                        title: "lk",
                        description: "fgh",
                        link: "asd",
                        date: .now,
                        synched: .now,
                        status: .new)

        await cloud.add(item: item)
        
        let new = await cloud.model.items.first?.status
        XCTAssertEqual(.new, new)
        
        await cloud.read(item: item)
        let items = await cloud.model.items
        XCTAssertEqual(.read, items.first?.status)
        XCTAssertEqual(1, items.count)
    }
    
    func testBookmarked() async {
        let item = Item(feed: .reutersInternational,
                         title: "lk",
                         description: "fgh",
                         link: "asd",
                         date: .now,
                         synched: .now,
                         status: .new)
        await cloud.add(item: item)
        await cloud.bookmark(item: item)
        let items = await cloud.model.items
        XCTAssertEqual(.bookmarked, items.first?.status)
        XCTAssertEqual(1, items.count)
    }
    
    func testUnbookmark() async {
        var item = Item(feed: .reutersInternational,
                         title: "lk",
                         description: "fgh",
                         link: "asd",
                         date: .now,
                         synched: .now,
                         status: .new)
        await cloud.add(item: item)
        item = await cloud.model.items.first!
        await cloud.bookmark(item: item)
        item = await cloud.model.items.first!
        await cloud.unbookmark(item: item)
        
        item = await cloud.model.items.first!
        let items = await cloud.model.items
        XCTAssertEqual(.read, item.status)
        XCTAssertEqual(1, items.count)
    }
    
    func testBookmarkedAndRead() async {
        var item = Item(feed: .reutersInternational,
                         title: "lk",
                         description: "fgh",
                         link: "asd",
                         date: .now,
                         synched: .now,
                         status: .new)
        await cloud.add(item: item)
        item = await cloud.model.items.first!
        await cloud.bookmark(item: item)
        item = await cloud.model.items.first!
        await cloud.read(item: item)
        
        item = await cloud.model.items.first!
        let items = await cloud.model.items
        XCTAssertEqual(.bookmarked, item.status)
        XCTAssertEqual(1, items.count)
    }
    
    func testDelete() async {
        let item = Item(feed: .reutersInternational,
                        title: "lk",
                        description: "fgh",
                        link: "asd",
                        date: .now,
                        synched: .now,
                        status: .new)

        await cloud.add(item: item)
        
        var items = await cloud.model.items
        XCTAssertEqual(1, items.count)
        
        await cloud.delete(item: item)
        items = await cloud.model.items
        XCTAssertTrue(items.isEmpty)
        
        await cloud.add(item: item)
        await cloud.read(item: item)
        await cloud.delete(item: item)
        items = await cloud.model.items
        XCTAssertTrue(items.isEmpty)
    }
    
    func testHistory() async {
        await cloud.toggle(.reutersInternational, true)
        
        let itemA = Item(feed: .reutersInternational,
                        title: "lk",
                        description: "fgh",
                        link: "asd1",
                        date: .now,
                        synched: .now,
                        status: .new)
        
        let itemB = Item(feed: .reutersInternational,
                        title: "lk",
                        description: "fgh",
                        link: "asd2",
                        date: .now,
                        synched: .now,
                        status: .new)
        
        var history = await cloud.model.history
        XCTAssertTrue(history.isEmpty)
        
        await cloud.read(item: itemA)
        history = await cloud.model.history
        XCTAssertEqual(itemA.link, history.first)
        
        await cloud.read(item: itemB)
        history = await cloud.model.history
        XCTAssertEqual(itemB.link, history.first)
        XCTAssertEqual(itemA.link, history.last)
        XCTAssertEqual(2, history.count)
        
        await cloud.read(item: itemA)
        history = await cloud.model.history
        XCTAssertEqual(itemA.link, history.first)
        XCTAssertEqual(itemB.link, history.last)
        XCTAssertEqual(2, history.count)
    }
    
    func testRecents() async {
        await cloud.toggle(.reutersInternational, true)
        
        let item = Item(feed: .reutersInternational,
                        title: "lk",
                        description: "fgh",
                        link: "asd",
                        date: .now,
                        synched: .now,
                        status: .new)
        
        var recents = await cloud.model.recents
        XCTAssertTrue(recents.isEmpty)
        
        await cloud.add(item: item)
        await cloud.read(item: item)
        recents = await cloud.model.recents
        XCTAssertEqual(item.link, recents.first?.link)
        
        await cloud.delete(item: item)
        recents = await cloud.model.recents
        let items = await cloud.model.items
        let history = await cloud.model.history
        XCTAssertTrue(recents.isEmpty)
        XCTAssertTrue(items.isEmpty)
        XCTAssertEqual(item.link, history.first)
    }
    
    func testRecentsLimit10() async {
        await cloud.toggle(.reutersInternational, true)
        
        let items = (0 ... 15)
            .map {
                Item(feed: .reutersInternational,
                                title: "lk",
                                description: "fgh",
                                link: "\($0)asd",
                                date: .now,
                                synched: .now,
                                status: .new)
            }
        
        for item in items {
            await cloud.read(item: item)
        }
        
        let recents = await cloud.model.recents
        XCTAssertEqual(10, recents.count)
    }
    
    func testRecentsCleanDeleted() async {
        await cloud.toggle(.reutersInternational, true)
        
        let items = (0 ... 3)
            .map {
                Item(feed: .reutersInternational,
                                title: "lk",
                                description: "fgh",
                                link: "\($0)asd",
                                date: .now,
                                synched: .now,
                                status: .new)
            }
        
        await cloud.read(item: items[0])
        await cloud.read(item: items[1])
        await cloud.read(item: items[2])
        await cloud.delete(item: items[1])
        await cloud.delete(item: items[2])
        await cloud.read(item: items[3])
        
        let recents = await cloud.model.recents
        let history = await cloud.model.history
        
        XCTAssertEqual(2, recents.count)
        XCTAssertEqual(recents.first?.link, items[3].link)
        XCTAssertEqual(recents.last?.link, items[0].link)
        
        XCTAssertEqual(2, history.count)
        XCTAssertEqual(history.first, items[3].link)
        XCTAssertEqual(history.last, items[0].link)
    }
    
    func testRecentsCleanDeactivated() async {
        await cloud.toggle(.reutersInternational, true)
        await cloud.toggle(.derSpiegelInternational, true)
        
        let items = (0 ... 3)
            .map {
                Item(feed: $0 == 3 ? .reutersInternational : .derSpiegelInternational,
                                title: "lk",
                                description: "fgh",
                                link: "\($0)asd",
                                date: .now,
                                synched: .now,
                                status: .new)
            }
        
        await cloud.read(item: items[0])
        await cloud.read(item: items[1])
        await cloud.read(item: items[2])
        await cloud.toggle(.derSpiegelInternational, false)
        await cloud.read(item: items[3])
        
        let history = await cloud.model.history
    
        XCTAssertEqual(1, history.count)
        XCTAssertEqual(history.first, items[3].link)
    }
}

private extension Cloud where Output == Archive {
    func add(item: Item) {
        model.items = model.items.inserting(item)
    }
    
    func toggle(_ feed: Feed, _ value: Bool) {
        model.preferences.feeds[feed] = value
    }
}
