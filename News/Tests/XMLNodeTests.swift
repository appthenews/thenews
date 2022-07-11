import XCTest
@testable import News

final class XMLNodeTests: XCTestCase {
    private var fetcher: Fetcher!
    private var data: Data!
    
    override func setUp() {
        fetcher = .init()
        data = .init(xml.utf8)
    }
    
    func testParse() throws {
        let result = try fetcher.parse(feed: .theLocalInternational, data: data, synched: []).items.first
        XCTAssertEqual("hello", result?.description)
    }
}

private let xml = """
<?xml version=\"1.0\" encoding=\"UTF-8\"?><rss version=\"2.0\"\n\txmlns:content=\"http://purl.org/rss/1.0/modules/content/\"\n\txmlns:wfw=\"http://wellformedweb.org/CommentAPI/\"\n\txmlns:dc=\"http://purl.org/dc/elements/1.1/\"\n\txmlns:atom=\"http://www.w3.org/2005/Atom\"\n\txmlns:sy=\"http://purl.org/rss/1.0/modules/syndication/\"\n\txmlns:slash=\"http://purl.org/rss/1.0/modules/slash/\"\n\t>\n\n<channel>\n\t<title>Reuters News Agency</title>\n\t<atom:link href=\"https://www.reutersagency.com/feed/?taxonomy=best-regions&#038;post_type=best\" rel=\"self\" type=\"application/rss+xml\" />\n\t<link>https://www.reutersagency.com/en/</link>\n\t<description></description>\n\t<lastBuildDate>Thu, 19 May 2022 12:22:53 +0000</lastBuildDate>\n\t<language>en-US</language>\n\t<sy:updatePeriod>\n\thourly\t</sy:updatePeriod>\n\t<sy:updateFrequency>\n\t1\t</sy:updateFrequency>\n\t<generator>https://wordpress.org/?v=5.8.4</generator>\n\n<image>\n\t<url>https://www.reutersagency.com/wp-content/uploads/2019/06/fav-150x150.png</url>\n\t<title>Reuters News Agency</title>\n\t<link>https://www.reutersagency.com/en/</link>\n\t<width>32</width>\n\t<height>32</height>\n</image> \n\t<item>\n\t\t<title>Reuters reveals Germany, Qatar at odds over terms in talks on LNG supply deal</title>\n\t\t<link>https://www.reutersagency.com/en/reutersbest/article/reuters-reveals-germany-qatar-at-odds-over-terms-in-talks-on-lng-supply-deal/</link>\n\t\t\n\t\t<dc:creator><![CDATA[Jaime-Lee Charles]]></dc:creator>\n\t\t<pubDate>Mon, 09 May 2022 21:00:00 +0000</pubDate>\n\t\t\t\t<guid isPermaLink=\"false\">https://www.reutersagency.com/en/?post_type=best&#038;p=290529</guid>\n\n\t\t\t\t\t<description><![CDATA[<p>Reuters revealed that Germany and Qatar have hit difficulties in talks over long-term liquefied natural gas (LNG) supply deals amid differences over [&#8230;]</p>\n<p>The post <a rel=\"nofollow\" href=\"https://www.reutersagency.com/en/reutersbest/article/reuters-reveals-germany-qatar-at-odds-over-terms-in-talks-on-lng-supply-deal/\">Reuters reveals Germany, Qatar at odds over terms in talks on LNG supply deal</a> appeared first on <a rel=\"nofollow\" href=\"https://www.reutersagency.com/en/\">Reuters News Agency</a>.</p>\n]]></description>\n\t\t\t\t\t\t\t\t\t\t<content:encoded><![CDATA[\n<p>Reuters <a href=\"https://app.assets.reuters.com/e/er?utm_campaign=&amp;utm_medium=email&amp;utm_source=Eloqua&amp;utm_content=B2B%20220512%20NEWS%20GLOB%20REUTERS%20BEST%20AWARE%20NWSLTR%20WEEKLY&amp;s=2124157686&amp;lid=26152&amp;elqTrackId=88970B964CACE67961C399CE0874E7F0&amp;elq=a2a051c1937e4d0f8b054e3c833cf5d0&amp;elqaid=2062&amp;elqat=1\" target=\"_blank\" rel=\"noreferrer noopener\">revealed</a> that Germany and Qatar have hit difficulties in talks over long-term liquefied natural gas (LNG) supply deals amid differences over key conditions, including the duration of any contract. Germany, which aims to cut its carbon emissions by 88% by 2040, is reluctant to commit to Qatar&#8217;s conditions to sign deals of at least 20 years to secure the massive LNG volumes it needs to reduce its dependence on Russian gas.</p>\n<p>The post <a rel=\"nofollow\" href=\"https://www.reutersagency.com/en/reutersbest/article/reuters-reveals-germany-qatar-at-odds-over-terms-in-talks-on-lng-supply-deal/\">Reuters reveals Germany, Qatar at odds over terms in talks on LNG supply deal</a> appeared first on <a rel=\"nofollow\" href=\"https://www.reutersagency.com/en/\">Reuters News Agency</a>.</p>\n]]></content:encoded>\n\t\t\t\t\t\n\t\t\n\t\t\n\t\t\t</item>\n\t</channel>\n</rss>\n
"""
