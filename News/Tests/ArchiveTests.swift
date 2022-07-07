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
        let article = Date(timestamp: 123569754)
        let synched = Date(timestamp: 35344)
        
        archive.preferences.delete = .week
        archive.preferences.fetch = .hours3
        archive.preferences.sources[.reutersEurope] = true
        archive.preferences.sources[.theLocalGermany] = true
        archive.history[.theLocalInternational] = History().update(cleaning: .hours3,
                                                                   adding: ["hello", "world"],
                                                                   and: [.init(title: "lorem",
                                                                               description: "billy idol",
                                                                               link: "eyes without a face",
                                                                               date: article,
                                                                               synched: synched,
                                                                               status: .bookmarked)])
        archive = await Archive(version: Archive.version, timestamp: archive.timestamp, data: archive.data)
        
        XCTAssertEqual(.week, archive.preferences.delete)
        XCTAssertEqual(.hours3, archive.preferences.fetch)
        XCTAssertTrue(archive.preferences.sources[.reutersEurope] ?? false)
        XCTAssertTrue(archive.preferences.sources[.theLocalGermany] ?? false)
        XCTAssertFalse(archive.preferences.sources[.theLocalInternational] ?? true)
        XCTAssertEqual(0, archive.history[.reutersInternational]?.synched.timestamp)
        XCTAssertGreaterThanOrEqual(archive.history[.theLocalInternational]?.synched.timestamp ?? 0, date.timestamp)
        XCTAssertEqual(2, archive.history[.theLocalInternational]?.ids.count)
        XCTAssertEqual(1, archive.history[.theLocalInternational]?.items.count)
        XCTAssertTrue(archive.history[.theLocalInternational]?.ids.contains("hello") ?? false)
        XCTAssertTrue(archive.history[.theLocalInternational]?.ids.contains("world") ?? false)
        XCTAssertEqual(article, archive.history[.theLocalInternational]?.items.first?.date)
        XCTAssertEqual(synched, archive.history[.theLocalInternational]?.items.first?.synched)
        XCTAssertEqual("lorem", archive.history[.theLocalInternational]?.items.first?.title)
        XCTAssertEqual("billy idol", archive.history[.theLocalInternational]?.items.first?.description)
        XCTAssertEqual("eyes without a face", archive.history[.theLocalInternational]?.items.first?.link)
        XCTAssertEqual(.bookmarked, archive.history[.theLocalInternational]?.items.first?.status)
    }
    
    func testFetchable() {
        XCTAssertEqual([], archive.fetchable)
        
        archive.preferences.sources[.theLocalGermany] = true
        XCTAssertEqual([.theLocalGermany], archive.fetchable)
        
        archive.preferences.sources[.theLocalInternational] = true
        XCTAssertEqual([.theLocalGermany, .theLocalInternational], archive.fetchable)
        
        var data = History().data.dropLast(4).adding(Calendar.current.date(byAdding: .hour, value: -3, to: .now)!)
        archive.history[.theLocalGermany] = .init(data: &data)
        XCTAssertEqual([.theLocalInternational], archive.fetchable)
        
        archive.preferences.fetch = .hours3
        XCTAssertEqual([.theLocalGermany, .theLocalInternational], archive.fetchable)
    }
}
