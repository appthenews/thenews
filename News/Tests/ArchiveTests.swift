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
        
        archive.preferences.clean = .week
        archive.preferences.fetch = .hours3
        archive.preferences.feeds[.reutersEurope] = true
        archive.preferences.feeds[.theLocalGermany] = true
        archive.update(feed: .theLocalInternational,
                       date: .now,
                       items: [.init(feed: .reutersInternational,
                                     title: "lorem",
                                     description: "billy idol",
                                     link: "eyes without a face",
                                     date: article,
                                     synched: synched,
                                     status: .bookmarked)])
        archive = await Archive(version: Archive.version, timestamp: archive.timestamp, data: archive.data)
        
        XCTAssertEqual(.week, archive.preferences.clean)
        XCTAssertEqual(.hours3, archive.preferences.fetch)
        XCTAssertTrue(archive.preferences.feeds[.reutersEurope]!)
        XCTAssertTrue(archive.preferences.feeds[.theLocalGermany]!)
        XCTAssertFalse(archive.preferences.feeds[.theLocalInternational]!)
        XCTAssertEqual(0, archive.feeds[.reutersInternational]!.timestamp)
        XCTAssertGreaterThanOrEqual(archive.feeds[.theLocalInternational]!.timestamp, date.timestamp)
        XCTAssertEqual(1, archive.links.count)
        XCTAssertEqual(1, archive.items.count)
        XCTAssertTrue(archive.links.contains("eyes without a face"))
        XCTAssertEqual(.reutersInternational, archive.items.first?.feed)
        XCTAssertEqual(article, archive.items.first?.date)
        XCTAssertEqual(synched, archive.items.first?.synched)
        XCTAssertEqual("lorem", archive.items.first?.title)
        XCTAssertEqual("billy idol", archive.items.first?.description)
        XCTAssertEqual("eyes without a face", archive.items.first?.link)
        XCTAssertEqual(.bookmarked, archive.items.first?.status)
    }
    
    func testFetchable() {
        XCTAssertEqual([], archive.fetchable)
        
        archive.preferences.feeds[.theLocalGermany] = true
        XCTAssertEqual([.theLocalGermany], archive.fetchable)
        
        archive.preferences.feeds[.theLocalInternational] = true
        XCTAssertEqual([.theLocalGermany, .theLocalInternational], archive.fetchable)
        
        archive.update(feed: .theLocalGermany,
                       date: Calendar.current.date(byAdding: .hour, value: -2, to: .now)!,
                       items: [])
        XCTAssertEqual([.theLocalInternational], archive.fetchable)
        
        archive.preferences.fetch = .hour
        XCTAssertEqual([.theLocalGermany, .theLocalInternational], archive.fetchable)
        
        archive.update(feed: .theLocalInternational, date: .now, items: [])
        XCTAssertEqual([.theLocalGermany], archive.fetchable)
    }
    
    func testItems() {
        archive.preferences.feeds[.reutersEurope] = true
        archive.preferences.feeds[.theLocalGermany] = true
        
        archive.update(feed: .reutersEurope,
                       date: .now,
                       items: [.init(feed: .reutersEurope,
                                     title: "asd",
                                     description: "dfg",
                                     link: "1",
                                     date: .init(timeIntervalSinceNow: -2),
                                     synched: .now,
                                     status: .new),
                               .init(feed: .reutersEurope,
                                     title: "asd",
                                     description: "dfg",
                                     link: "2",
                                     date: .init(timeIntervalSinceNow: -6),
                                     synched: .now,
                                     status: .new),
                               .init(feed: .theLocalGermany,
                                     title: "asd",
                                     description: "dfg",
                                     link: "3",
                                     date: .init(timeIntervalSinceNow: -4),
                                     synched: .now,
                                     status: .new),
                               .init(feed: .derSpiegelInternational,
                                     title: "asd",
                                     description: "dfg",
                                     link: "4",
                                     date: .init(timeIntervalSinceNow: -1),
                                     synched: .now,
                                     status: .new)])
        
        var items = archive.items(provider: .reuters).sorted()
        XCTAssertEqual(2, items.count)
        XCTAssertEqual("1", items.first?.link)
        XCTAssertEqual("2", items.last?.link)
        
        items = archive.items(provider: .all).sorted()
        XCTAssertEqual(3, items.count)
        XCTAssertEqual(.reutersEurope, items.first?.feed)
        XCTAssertEqual(.theLocalGermany, items[1].feed)
        XCTAssertEqual(.reutersEurope, items.last?.feed)
        XCTAssertEqual("1", items.first?.link)
        XCTAssertEqual("2", items.last?.link)
    }
    
    func testClean() {
        archive.update(feed: .theLocalInternational,
                       date: .now,
                       items: [.init(feed: .theLocalGermany,
                                     title: "asd",
                                     description: "rtg",
                                     link: "f",
                                     date: .now,
                                     synched: Calendar.current.date(byAdding: .hour, value: -3, to: .now)!,
                                     status: .new)])
        
        XCTAssertEqual(1, archive.links.count)
        XCTAssertEqual(1, archive.items.count)
        
        archive.update(feed: .theLocalGermany,
                       date: .now,
                       items: [.init(feed: .reutersEurope,
                                     title: "jj",
                                     description: "uu",
                                     link: "ii",
                                     date: .now,
                                     synched: .now,
                                     status: .new)])
        
        archive.clean()
        
        XCTAssertEqual(2, archive.links.count)
        XCTAssertEqual(2, archive.items.count)
        
        archive.preferences.clean = .hours3
        archive.clean()
        
        XCTAssertEqual(2, archive.links.count)
        XCTAssertEqual(1, archive.items.count)
        XCTAssertEqual("jj", archive.items.first?.title)
    }
    
    func testBookmarked() {
        let item = Item(feed: .theLocalGermany,
                         title: "asd",
                         description: "rtg",
                         link: "f",
                         date: .now,
                         synched: Calendar.current.date(byAdding: .hour, value: -3, to: .now)!,
                         status: .new)
        
        archive.items = archive.items.inserting(item.bookmarked)
        archive.preferences.clean = .hours3
        archive.clean()
        
        XCTAssertEqual(1, archive.items.count)
    }
    
    func testUpdate() {
        archive.update(feed: .theLocalInternational,
                       date: .now,
                       items: [.init(feed: .reutersInternational,
                                     title: "lorem",
                                     description: "billy idol",
                                     link: "eyes without a face",
                                     date: .now,
                                     synched: .now,
                                     status: .new)])
        XCTAssertEqual(1, archive.items.count)
        XCTAssertEqual(1, archive.links.count)
        
        archive.update(feed: .theLocalInternational,
                       date: .now,
                       items: [.init(feed: .reutersEurope,
                                     title: "ipsum",
                                     description: "total",
                                     link: "eyes without a face",
                                     date: .distantPast,
                                     synched: .distantPast,
                                     status: .bookmarked)])
        XCTAssertEqual(1, archive.items.count)
        XCTAssertEqual(1, archive.links.count)
    }
}
