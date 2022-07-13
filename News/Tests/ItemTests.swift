import XCTest
@testable import News

final class ItemTests: XCTestCase {
    func testRecent() {
        var item = Item(feed: .derSpiegelInternational,
                        title: "asd",
                        description: "def",
                        link: "gfdgd",
                        date: .now,
                        synched: .now,
                        status: .new)
        XCTAssertTrue(item.recent)
        
        item = item.read
        XCTAssertFalse(item.recent)
        
        item = item.bookmarked
        XCTAssertFalse(item.recent)
        
        item = .init(feed: .derSpiegelInternational,
                     title: "asd",
                     description: "def",
                     link: "gfdgd",
                     date: .now,
                     synched: Calendar.current.date(byAdding: .hour, value: -2, to: .now)!,
                     status: .new)
        XCTAssertFalse(item.recent)
    }
    
    func testFilter() {
        let items = [Item(feed: .derSpiegelInternational,
                          title: "asd",
                          description: "def",
                          link: "gfdgd",
                          date: .now,
                          synched: Calendar.current.date(byAdding: .hour, value: -2, to: .now)!,
                          status: .new),
                     .init(feed: .reutersEurope,
                           title: "fdsgsfdfsd",
                           description: "gfsgfgs",
                           link: "hfgfh",
                           date: .now,
                           synched: .now,
                           status: .new)]
        
        XCTAssertTrue(items.filter(search: "lol").isEmpty)
        XCTAssertEqual(1, items.filter(search: "sg").count)
        XCTAssertEqual(2, items.filter(search: "g").count)
        XCTAssertEqual(2, items.filter(search: "").count)
    }
    
    func testEquallity() {
        let item = Item(feed: .derSpiegelInternational,
                          title: "asd",
                          description: "def",
                          link: "gfdgd",
                          date: .now,
                          synched: Calendar.current.date(byAdding: .hour, value: -2, to: .now)!,
                          status: .new)
        XCTAssertNotEqual(item, item.read)
    }
}
