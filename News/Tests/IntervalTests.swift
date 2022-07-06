import XCTest
@testable import News

final class IntervalTests: XCTestCase {
    func testPassed() {
        XCTAssertFalse(Interval.hours3.passed(date: .now))
        XCTAssertFalse(Interval.hours6.passed(date: .now))
        
        let hours3 = Calendar.current.date(byAdding: .hour, value: -3, to: .now)!
        XCTAssertTrue(Interval.hours3.passed(date: hours3))
        XCTAssertFalse(Interval.hours6.passed(date: hours3))
    }
}
