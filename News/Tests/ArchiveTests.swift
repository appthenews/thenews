import XCTest
@testable import Archivable
@testable import News

final class ArchiveTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .init()
    }
    
    func testPreferences() async {
        archive.preferences.delete = .week
        archive.preferences.fetch = .hours3
        archive.preferences.sources[.reutersEurope] = true
        archive.preferences.sources[.theLocalGermany] = true
        archive = await Archive(version: Archive.version, timestamp: archive.timestamp, data: archive.data)
        
        XCTAssertEqual(.week, archive.preferences.delete)
        XCTAssertEqual(.hours3, archive.preferences.fetch)
        XCTAssertTrue(archive.preferences.sources[.reutersEurope] ?? false)
        XCTAssertTrue(archive.preferences.sources[.theLocalGermany] ?? false)
        XCTAssertFalse(archive.preferences.sources[.theLocalInternational] ?? true)
    }
}
