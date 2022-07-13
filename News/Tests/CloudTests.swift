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
        await cloud.bookmarked(item: item)
        let items = await cloud.model.items
        XCTAssertEqual(.bookmarked, items.first?.status)
        XCTAssertEqual(1, items.count)
    }
}

private extension Cloud where Output == Archive {
    func add(item: Item) {
        model.items = model.items.inserting(item)
    }
}
