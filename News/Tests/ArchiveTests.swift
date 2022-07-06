import XCTest
@testable import Archivable
@testable import News

final class ArchiveTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .init()
    }
    
    func testParse() async {
        let date = Date.now
        archive.preferences.delete = .week
        archive.preferences.fetch = .hours3
        archive.preferences.sources[.reutersEurope] = true
        archive.preferences.sources[.theLocalGermany] = true
        archive.history[.theLocalInternational] = .init(ids: [], items: [], synched: .now)
        archive = await Archive(version: Archive.version, timestamp: archive.timestamp, data: archive.data)
        
        XCTAssertEqual(.week, archive.preferences.delete)
        XCTAssertEqual(.hours3, archive.preferences.fetch)
        XCTAssertTrue(archive.preferences.sources[.reutersEurope] ?? false)
        XCTAssertTrue(archive.preferences.sources[.theLocalGermany] ?? false)
        XCTAssertFalse(archive.preferences.sources[.theLocalInternational] ?? true)
        XCTAssertEqual(0, archive.history[.reutersInternational]?.synched.timestamp)
        XCTAssertGreaterThanOrEqual(archive.history[.theLocalInternational]?.synched.timestamp ?? 0, date.timestamp)
    }
    
    func testFetchable() {
        XCTAssertEqual([], archive.fetchable)
        
        archive.preferences.sources[.theLocalGermany] = true
        XCTAssertEqual([.theLocalGermany], archive.fetchable)
        
        archive.preferences.sources[.theLocalInternational] = true
        XCTAssertEqual([.theLocalGermany, .theLocalInternational], archive.fetchable)
        
        archive.history[.theLocalGermany] = .init(ids: [], items: [], synched: Calendar.current.date(byAdding: .hour, value: -3, to: .now)!)
        XCTAssertEqual([.theLocalInternational], archive.fetchable)
        
        archive.preferences.fetch = .hours3
        XCTAssertEqual([.theLocalGermany, .theLocalInternational], archive.fetchable)
    }
}
