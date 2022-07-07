import XCTest
@testable import Archivable
@testable import News

final class CloudTests: XCTestCase {
    private var cloud: Cloud<Archive, MockContainer>!
    
    override func setUp() {
        cloud = .init()
    }
    
    func testRead() async {
        let item = Item(title: "lk",
                         description: "fgh",
                         link: "asd",
                         date: .now,
                         synched: .now,
                         status: .new)
        let history = [Source.reutersEurope : History()
            .update(cleaning: .hours3,
                    adding: [],
                    and: [item])]
        await cloud.update(history: history)
        
        await cloud.read(source: .reutersEurope, item: item)
        let read = await cloud.model.history[.reutersEurope]?.items.first?.status
        
        XCTAssertEqual(.read, read)
    }
    
    func testBookmarked() async {
        let item = Item(title: "lk",
                         description: "fgh",
                         link: "asd",
                         date: .now,
                         synched: .now,
                         status: .new)
        let history = [Source.reutersEurope : History()
            .update(cleaning: .hours3,
                    adding: [],
                    and: [item])]
        await cloud.update(history: history)
        
        await cloud.bookmarked(source: .reutersEurope, item: item)
        let bookmarked = await cloud.model.history[.reutersEurope]?.items.first?.status
        
        XCTAssertEqual(.bookmarked, bookmarked)
    }
}

private extension Cloud where Output == Archive {
    func update(history: [Source : History]) {
        model.history = history
    }
}
