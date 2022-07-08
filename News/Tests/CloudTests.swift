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

        await cloud.update(item: item)
        let new = await cloud.model.items.first?.status
        XCTAssertEqual(.new, new)
        
        await cloud.read(item: item)
        let read = await cloud.model.items.first?.status
        XCTAssertEqual(.read, read)
    }
    
    func testBookmarked() async {
        await cloud.bookmarked(item: .init(feed: .reutersInternational,
                                          title: "lk",
                                          description: "fgh",
                                          link: "asd",
                                          date: .now,
                                          synched: .now,
                                          status: .new))
        let bookmarked = await cloud.model.items.first?.status
        
        XCTAssertEqual(.bookmarked, bookmarked)
    }
}

private extension Cloud where Output == Archive {
    func update(item: Item) {
        model.update(item: item)
    }
}
