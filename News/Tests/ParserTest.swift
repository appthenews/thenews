import XCTest
@testable import News

final class ParserTest: XCTestCase {
    func testParse() async throws {
        let result = try await Fetcher().parse(feed: .theLocalInternational, data: .init(xml.utf8)).first
        XCTAssertEqual("Reuters revealed that Germany and Qatar have hit difficulties in talks over long-term liquefied natural gas (LNG) supply deals amid differences over […]\n\nThe post Reuters reveals Germany, Qatar at odds over terms in talks on LNG supply deal appeared first on Reuters News Agency.", result?.description)
    }
    
    func testSpacialCases() async throws {
        var string = "<html> <body> <h1>My First Heading</h1> <p>My first paragraph.</p> </body> </html>"
        var result = try await Parser(html: string).result
        XCTAssertEqual("My First Heading My first paragraph.", result)
        
        string = "LCD Soundsystem was the musical project of producer <a href='http://www.last.fm/music/James+Murphy' class='bbcode_artist'>James Murphy</a>, co-founder of <a href='http://www.last.fm/tag/dance-punk' class='bbcode_tag' rel='tag'>dance-punk</a> label <a href='http://www.last.fm/label/DFA' class='bbcode_label'>DFA</a> Records. Formed in 2001 in New York City, New York, United States, the music of LCD Soundsystem can also be described as a mix of <a href='http://www.last.fm/tag/alternative%20dance' class='bbcode_tag' rel='tag'>alternative dance</a> and <a href='http://www.last.fm/tag/post%20punk' class='bbcode_tag' rel='tag'>post punk</a>, along with elements of <a href='http://www.last.fm/tag/disco' class='bbcode_tag' rel='tag'>disco</a> and other styles. <br />"
        result = try await Parser(html: string).result
        XCTAssertEqual("LCD Soundsystem was the musical project of producer James Murphy, co-founder of dance-punk label DFA Records. Formed in 2001 in New York City, New York, United States, the music of LCD Soundsystem can also be described as a mix of alternative dance and post punk, along with elements of disco and other styles.", result)
        
        string = "my html <a href=\"\">link text</a>"
        result = try await Parser(html: string).result
        XCTAssertEqual("my html link text", result)
        
        string = ""
        result = try await Parser(html: string).result
        XCTAssertEqual("", result)
        
        string = "hello"
        result = try await Parser(html: string).result
        XCTAssertEqual("hello", result)
        
        string = "hello\nworld"
        result = try await Parser(html: string).result
        XCTAssertEqual("hello\nworld", result)
        
        string = "hello<br>world"
        result = try await Parser(html: string).result
        XCTAssertEqual("hello\nworld", result)
        
        string = """
<p>Brad Beddoes tells inquest he thought there were only two people in the car and told relative the investigation was ‘completed’</p><ul><li>Get our <a href=\"https://www.theguardian.com/technology/ng-interactive/2018/may/15/the-guardian-app?CMP=cvau_sfl\">free news app</a>, <a href=\"https://www.theguardian.com/world/guardian-australia-morning-mail/2014/jun/24/-sp-guardian-australias-morning-mail-subscribe-by-email?CMP=cvau_sfl\">morning email briefing</a> and <a href=\"https://www.theguardian.com/australia-news/series/full-story?CMP=cvau_sfl\">daily news podcast</a></li></ul><p>A senior detective has told an inquest examining the drowning death of Gordon Copeland he believed he had done his “absolute best” to locate the missing 22-year-old but he didn’t have all the relevant information.</p><p>On Wednesday the inquest was told Copeland’s family waited for hours in the Moree police station trying to get further information about his whereabouts only to be told the investigation was “completed”.</p><p><a href=\"https://www.theguardian.com/world/guardian-australia-morning-mail/2014/jun/24/-sp-guardian-australias-morning-mail-subscribe-by-email?CMP=copyembed\">Sign up to receive an email with the top stories from Guardian Australia every morning</a></p> <a href=\"https://www.theguardian.com/australia-news/2022/jul/27/gordon-copeland-inquest-detective-says-he-did-his-absolute-best-but-didnt-have-all-information\">Continue reading...</a>
"""
        result = try await Parser(html: string).result
        XCTAssertEqual("""
Brad Beddoes tells inquest he thought there were only two people in the car and told relative the investigation was ‘completed’
Get our free news app, morning email briefing and daily news podcast
A senior detective has told an inquest examining the drowning death of Gordon Copeland he believed he had done his “absolute best” to locate the missing 22-year-old but he didn’t have all the relevant information.
On Wednesday the inquest was told Copeland’s family waited for hours in the Moree police station trying to get further information about his whereabouts only to be told the investigation was “completed”.
Sign up to receive an email with the top stories from Guardian Australia every morning
Continue reading...
""", result)
    }
}

private let xml = """
<?xml version=\"1.0\" encoding=\"UTF-8\"?><rss version=\"2.0\"\n\txmlns:content=\"http://purl.org/rss/1.0/modules/content/\"\n\txmlns:wfw=\"http://wellformedweb.org/CommentAPI/\"\n\txmlns:dc=\"http://purl.org/dc/elements/1.1/\"\n\txmlns:atom=\"http://www.w3.org/2005/Atom\"\n\txmlns:sy=\"http://purl.org/rss/1.0/modules/syndication/\"\n\txmlns:slash=\"http://purl.org/rss/1.0/modules/slash/\"\n\t>\n\n<channel>\n\t<title>Reuters News Agency</title>\n\t<atom:link href=\"https://www.reutersagency.com/feed/?taxonomy=best-regions&#038;post_type=best\" rel=\"self\" type=\"application/rss+xml\" />\n\t<link>https://www.reutersagency.com/en/</link>\n\t<description></description>\n\t<lastBuildDate>Thu, 19 May 2022 12:22:53 +0000</lastBuildDate>\n\t<language>en-US</language>\n\t<sy:updatePeriod>\n\thourly\t</sy:updatePeriod>\n\t<sy:updateFrequency>\n\t1\t</sy:updateFrequency>\n\t<generator>https://wordpress.org/?v=5.8.4</generator>\n\n<image>\n\t<url>https://www.reutersagency.com/wp-content/uploads/2019/06/fav-150x150.png</url>\n\t<title>Reuters News Agency</title>\n\t<link>https://www.reutersagency.com/en/</link>\n\t<width>32</width>\n\t<height>32</height>\n</image> \n\t<item>\n\t\t<title>Reuters reveals Germany, Qatar at odds over terms in talks on LNG supply deal</title>\n\t\t<link>https://www.reutersagency.com/en/reutersbest/article/reuters-reveals-germany-qatar-at-odds-over-terms-in-talks-on-lng-supply-deal/</link>\n\t\t\n\t\t<dc:creator><![CDATA[Jaime-Lee Charles]]></dc:creator>\n\t\t<pubDate>Mon, 09 May 2022 21:00:00 +0000</pubDate>\n\t\t\t\t<guid isPermaLink=\"false\">https://www.reutersagency.com/en/?post_type=best&#038;p=290529</guid>\n\n\t\t\t\t\t<description><![CDATA[<p>Reuters revealed that Germany and Qatar have hit difficulties in talks over long-term liquefied natural gas (LNG) supply deals amid differences over [&#8230;]</p>\n<p>The post <a rel=\"nofollow\" href=\"https://www.reutersagency.com/en/reutersbest/article/reuters-reveals-germany-qatar-at-odds-over-terms-in-talks-on-lng-supply-deal/\">Reuters reveals Germany, Qatar at odds over terms in talks on LNG supply deal</a> appeared first on <a rel=\"nofollow\" href=\"https://www.reutersagency.com/en/\">Reuters News Agency</a>.</p>\n]]></description>\n\t\t\t\t\t\t\t\t\t\t<content:encoded><![CDATA[\n<p>Reuters <a href=\"https://app.assets.reuters.com/e/er?utm_campaign=&amp;utm_medium=email&amp;utm_source=Eloqua&amp;utm_content=B2B%20220512%20NEWS%20GLOB%20REUTERS%20BEST%20AWARE%20NWSLTR%20WEEKLY&amp;s=2124157686&amp;lid=26152&amp;elqTrackId=88970B964CACE67961C399CE0874E7F0&amp;elq=a2a051c1937e4d0f8b054e3c833cf5d0&amp;elqaid=2062&amp;elqat=1\" target=\"_blank\" rel=\"noreferrer noopener\">revealed</a> that Germany and Qatar have hit difficulties in talks over long-term liquefied natural gas (LNG) supply deals amid differences over key conditions, including the duration of any contract. Germany, which aims to cut its carbon emissions by 88% by 2040, is reluctant to commit to Qatar&#8217;s conditions to sign deals of at least 20 years to secure the massive LNG volumes it needs to reduce its dependence on Russian gas.</p>\n<p>The post <a rel=\"nofollow\" href=\"https://www.reutersagency.com/en/reutersbest/article/reuters-reveals-germany-qatar-at-odds-over-terms-in-talks-on-lng-supply-deal/\">Reuters reveals Germany, Qatar at odds over terms in talks on LNG supply deal</a> appeared first on <a rel=\"nofollow\" href=\"https://www.reutersagency.com/en/\">Reuters News Agency</a>.</p>\n]]></content:encoded>\n\t\t\t\t\t\n\t\t\n\t\t\n\t\t\t</item>\n\t</channel>\n</rss>\n
"""
