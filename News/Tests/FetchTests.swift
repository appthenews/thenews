import XCTest
@testable import News

final class FetchTests: XCTestCase {
    private var archive: Archive!
    private var fetcher: MockFetcher!
    
    override func setUp() {
        archive = .init()
        fetcher = .init()
    }
    
    func testPreferences() async {
        
    }
}

private struct MockFetcher: Fetch {
    var result: String?
}
