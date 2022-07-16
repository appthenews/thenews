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
        XCTAssertEqual(item.link, recents.first)
        
        await cloud.delete(item: item)
        recents = await cloud.model.recents
        let items = await cloud.model.items
        let history = await cloud.model.history
        XCTAssertTrue(recents.isEmpty)
        XCTAssertTrue(items.isEmpty)
        XCTAssertEqual(item.link, history.first)
    }
}

private extension Cloud where Output == Archive {
    func add(item: Item) {
        model.items = model.items.inserting(item)
    }
}
