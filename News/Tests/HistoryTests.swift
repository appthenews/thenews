import XCTest
@testable import News

final class HistoryTests: XCTestCase {
    func testUpdate() {
        var history = History()
        history = history.update(cleaning: .hours3, adding: ["hello"], and: [.init(title: "asd",
                                                                                   description: "rtg",
                                                                                   link: "f",
                                                                                   date: .now,
                                                                                   synched: .now)])
        XCTAssertEqual(1, history.ids.count)
        XCTAssertEqual(1, history.items.count)
        
        history = history.update(cleaning: .hours3, adding: ["world"], and: [.init(title: "jj",
                                                                                   description: "uu",
                                                                                   link: "ii",
                                                                                   date: .now,
                                                                                   synched: .now)])
        XCTAssertEqual(2, history.ids.count)
        XCTAssertEqual(2, history.items.count)
    }
    
    func testClean() {
        var history = History()
        history = history.update(cleaning: .hours3, adding: ["hello"], and: [.init(title: "asd",
                                                                                   description: "rtg",
                                                                                   link: "f",
                                                                                   date: .now,
                                                                                   synched: Calendar.current.date(byAdding: .hour, value: -3, to: .now)!)])
        XCTAssertEqual(1, history.ids.count)
        XCTAssertEqual(1, history.items.count)
        
        history = history.update(cleaning: .hours3, adding: ["world"], and: [.init(title: "jj",
                                                                                   description: "uu",
                                                                                   link: "ii",
                                                                                   date: .now,
                                                                                   synched: .now)])
        XCTAssertEqual(2, history.ids.count)
        XCTAssertEqual(1, history.items.count)
        XCTAssertEqual("jj", history.items.first?.title)
    }
}
