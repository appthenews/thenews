import XCTest
@testable import News

final class FormatTest: XCTestCase {
    func testP() async throws {
        let result = try await Parser(html: """
 <p>Critics of Kais Saied fear he will rip up democracy that emerged from 2011 revolution</p><p>Tunisians have begun voting in a referendum on a new constitution that critics of the president fear will dismantle the <a href=\"https://www.theguardian.com/world/2011/oct/19/tunisia-elections-revolution-future\">democracy that emerged from a 2011 revolution</a> by handing him nearly total power.</p><p>The vote is being held on the first anniversary of Kais Saied’s <a href=\"https://www.theguardian.com/world/2021/jul/26/tunisian-president-dismisses-government-sparking-street-celebrations\">ousting of an elected parliament</a>, when he established emergency rule and began governing by fiat.</p> <a href=\"https://www.theguardian.com/world/2022/jul/25/tunisians-vote-referendum-handing-president-kais-saied\">Continue reading...</a>
""").result
        
        XCTAssertEqual("""
Critics of Kais Saied fear he will rip up democracy that emerged from 2011 revolution
Tunisians have begun voting in a referendum on a new constitution that critics of the president fear will dismantle the democracy that emerged from a 2011 revolution by handing him nearly total power.
The vote is being held on the first anniversary of Kais Saied’s ousting of an elected parliament, when he established emergency rule and began governing by fiat.
Continue reading...
""", result)
    }
    
    func testDoubleSpace() async throws {
        let result = try await Parser(html: """
&lt;p&gt;Michoacán state suffers another temblor, felt as far  away as Colima, Jalisco and Guerrero states&lt;/p&gt;&lt;p&gt;A powerful magnitude 6.8 earthquake has struck Mexico, causing at least two deaths, damaging buildings and setting off landslides.&lt;/p&gt;&lt;p&gt;The earthquake struck at 1.19am on Thursday near the epicenter of &lt;a href=\"https://www.theguardian.com/world/2022/sep/19/mexico-earthquake-magnitude-central-pacific-coast\"&gt;a magnitude 7.6 quake that hit three days earlier in the western state of Michoacán&lt;/a&gt;. It was also blamed for two deaths.&lt;/p&gt; &lt;a href=\"https://www.theguardian.com/world/2022/sep/22/mexico-earthquake-michoacan\"&gt;Continue reading...&lt;/a&gt;
""").result
        
        XCTAssertEqual("""
<p>Michoacán state suffers another temblor, felt as far away as Colima, Jalisco and Guerrero states</p><p>A powerful magnitude 6.8 earthquake has struck Mexico, causing at least two deaths, damaging buildings and setting off landslides.</p><p>The earthquake struck at 1.19am on Thursday near the epicenter of <a href="https://www.theguardian.com/world/2022/sep/19/mexico-earthquake-magnitude-central-pacific-coast">a magnitude 7.6 quake that hit three days earlier in the western state of Michoacán</a>. It was also blamed for two deaths.</p> <a href="https://www.theguardian.com/world/2022/sep/22/mexico-earthquake-michoacan">Continue reading...</a>
""", result)
    }
    
    func testDoubleBr() async throws {
        let result = try await Parser(html: """
 <p>Officials announce eight cats will be brought from Namibia in effort to reintroduce animal to its former habitat</p><p>Cheetahs are to return to India’s forests this August for the first time in more than 70 years, officials have announced.</p><p>Eight wild cats from Namibia will roam freely at Kuno-Palpur national park in the state of Madhya Pradesh in efforts to reintroduce the animal to their natural habitat.<br><br>Despite being a vital part of India’s ecosystem, the cheetah was declared extinct from the country in 1952 because of habitat loss and poaching. Cheetahs can reach speeds of up to 70mph (113km/h), making them the world’s fastest land animal.<br><br>Only about 7,000 cheetahs remain in the wild worldwide and the animals are classified as a vulnerable species under the International Union for Conservation of Nature red list of threatened species. Namibia has the world’s largest population of cheetahs.<br><br>Officials have been working to relocate the animals since 2020, after India’s supreme court announced that African cheetahs could be brought back in a “carefully chosen location”.<br><br>The move coincides with the nation’s 75th Independence Day, celebrating cheetahs as an important part of India’s cultural heritage.<br><br><a href=\"https://twitter.com/byadavbjp/status/1549648868295421952\">India’s environment minister, Bhupender Yadav, tweeted</a>: “Completing 75 glorious years of Independence with restoring the fastest terrestrial flagship species, the cheetah, in India, will rekindle the ecological dynamics of the landscape.”<br><br>He added: “Cheetah reintroduction in India has a larger goal of re-establishing ecological function in Indian grasslands that was lost due to extinction of Asiatic cheetah. This is in conformity with IUCN guidelines on conservation translocations.”</p> <a href=\"https://www.theguardian.com/world/2022/jul/21/wild-cheetahs-to-return-to-india-for-first-time-since-1952\">Continue reading...</a>
""").result
        
        XCTAssertEqual("""
Officials announce eight cats will be brought from Namibia in effort to reintroduce animal to its former habitat
Cheetahs are to return to India’s forests this August for the first time in more than 70 years, officials have announced.
Eight wild cats from Namibia will roam freely at Kuno-Palpur national park in the state of Madhya Pradesh in efforts to reintroduce the animal to their natural habitat.
Despite being a vital part of India’s ecosystem, the cheetah was declared extinct from the country in 1952 because of habitat loss and poaching. Cheetahs can reach speeds of up to 70mph (113km/h), making them the world’s fastest land animal.
Only about 7,000 cheetahs remain in the wild worldwide and the animals are classified as a vulnerable species under the International Union for Conservation of Nature red list of threatened species. Namibia has the world’s largest population of cheetahs.
Officials have been working to relocate the animals since 2020, after India’s supreme court announced that African cheetahs could be brought back in a “carefully chosen location”.
The move coincides with the nation’s 75th Independence Day, celebrating cheetahs as an important part of India’s cultural heritage.
India’s environment minister, Bhupender Yadav, tweeted: “Completing 75 glorious years of Independence with restoring the fastest terrestrial flagship species, the cheetah, in India, will rekindle the ecological dynamics of the landscape.”
He added: “Cheetah reintroduction in India has a larger goal of re-establishing ecological function in Indian grasslands that was lost due to extinction of Asiatic cheetah. This is in conformity with IUCN guidelines on conservation translocations.”
Continue reading...
""", result)
    }
    
    func testNewLine() async throws {
        let result = try await Parser(html: """
 <p>Reuters revealed that Germany and Qatar have hit difficulties in talks over long-term liquefied natural gas (LNG) supply deals amid differences over [&#8230;]</p>\n<p>The post <a rel=\"nofollow\" href=\"https://www.reutersagency.com/en/reutersbest/article/reuters-reveals-germany-qatar-at-odds-over-terms-in-talks-on-lng-supply-deal/\">Reuters reveals Germany, Qatar at odds over terms in talks on LNG supply deal</a> appeared first on <a rel=\"nofollow\" href=\"https://www.reutersagency.com/en/\">Reuters News Agency</a>.</p>\n
""").result
        
        XCTAssertEqual("""
Reuters revealed that Germany and Qatar have hit difficulties in talks over long-term liquefied natural gas (LNG) supply deals amid differences over […]
The post Reuters reveals Germany, Qatar at odds over terms in talks on LNG supply deal appeared first on Reuters News Agency.
""", result)
    }
}
