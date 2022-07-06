import XCTest
@testable import News

final class FetchTests: XCTestCase {
    private var archive: Archive!
    private var fetcher: Fetcher!
    
    override func setUp() {
        archive = .init()
        fetcher = .init()
    }
    
}
