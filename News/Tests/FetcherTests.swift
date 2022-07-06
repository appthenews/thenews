import XCTest
@testable import News

final class FetchTests: XCTestCase {
    private var fetcher: Fetcher!
    private var data: Data!
    
    override func setUp() {
        fetcher = .init()
        data = .init(xml.utf8)
    }
    
    func testParse() throws {
        let result = try fetcher.parse(data: data, synched: [])
        XCTAssertEqual(20, result.ids.count)
        XCTAssertEqual(20, result.items.count)
        XCTAssertTrue(result.ids.contains("https://www.spiegel.de/international/world/a-visit-to-volodymyr-zelenskyy-s-hometown-kryvyi-rih-city-of-steel-a-95aa1a79-905c-462f-aa02-c61b103321f8"))
        XCTAssertTrue(result.items.contains { $0.link == "https://www.spiegel.de/international/germany/from-inflation-to-recession-is-germany-s-prosperity-at-risk-a-bd8650be-2075-40b9-a762-05e2baaf2a7d#ref=rss" })
    }
}


private let xml = """
<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><rss xmlns:content=\"http://purl.org/rss/1.0/modules/content/\" version=\"2.0\">\n<channel>\n<title>DER SPIEGEL - International</title>\n<link>https://www.spiegel.de/</link>\n<description>Deutschlands führende Nachrichtenseite. Alles Wichtige aus Politik, Wirtschaft, Sport, Kultur, Wissenschaft, Technik und mehr.</description>\n<language>de</language>\n<pubDate>Wed, 6 Jul 2022 16:51:17 +0200</pubDate>\n<lastBuildDate>Wed, 6 Jul 2022 16:51:17 +0200</lastBuildDate>\n<image>\n<title>DER SPIEGEL</title>\n<link>https://www.spiegel.de/</link>\n<url>https://www.spiegel.de/public/spon/images/logos/der-spiegel-h60.png</url>\n</image>\n<item>\n<title>A Visit to Volodymyr Zelenskyy\'s Hometown Kryvyi Rih: City of Steel</title>\n<link>https://www.spiegel.de/international/world/a-visit-to-volodymyr-zelenskyy-s-hometown-kryvyi-rih-city-of-steel-a-95aa1a79-905c-462f-aa02-c61b103321f8#ref=rss</link>\n<description>How did the actor Volodymyr Zelenskyy transform into a wartime president? Some answers can be found in his hometown, the heavy industry city of Kryvyi Rih. Pride in their famous son is palpable, as is a feeling that the war is drawing ever closer.</description>\n<enclosure type=\"image/jpeg\" url=\"https://cdn.prod.www.spiegel.de/images/83d07534-e77a-4a1c-b45f-5eacc29de2e0_w520_r2.08_fpx51.4_fpy54.99.jpg\"/>\n<guid>https://www.spiegel.de/international/world/a-visit-to-volodymyr-zelenskyy-s-hometown-kryvyi-rih-city-of-steel-a-95aa1a79-905c-462f-aa02-c61b103321f8</guid>\n<pubDate>Tue, 5 Jul 2022 16:39:15 +0200</pubDate>\n<content:encoded>How did the actor Volodymyr Zelenskyy transform into a wartime president? Some answers can be found in his hometown, the heavy industry city of Kryvyi Rih. Pride in their famous son is palpable, as is a feeling that the war is drawing ever closer.</content:encoded>\n</item>\n<item>\n<title>From Inflation to Recession: Is Germany\'s Prosperity at Risk?</title>\n<link>https://www.spiegel.de/international/germany/from-inflation-to-recession-is-germany-s-prosperity-at-risk-a-bd8650be-2075-40b9-a762-05e2baaf2a7d#ref=rss</link>\n<description>Germany is facing a deep crisis, with inflation is reaching record levels and recession on the horizon. Even the middle class has begun to feel the pain.</description>\n<enclosure type=\"image/jpeg\" url=\"https://cdn.prod.www.spiegel.de/images/38de43f5-2b82-4b9c-a116-4a10fdeed7f6_w520_r2.08_fpx56.2_fpy49.98.jpg\"/>\n<guid>https://www.spiegel.de/international/germany/from-inflation-to-recession-is-germany-s-prosperity-at-risk-a-bd8650be-2075-40b9-a762-05e2baaf2a7d</guid>\n<pubDate>Tue, 5 Jul 2022 16:23:59 +0200</pubDate>\n<content:encoded>Germany is facing a deep crisis, with inflation is reaching record levels and recession on the horizon. Even the middle class has begun to feel the pain.</content:encoded>\n</item>\n<item>\n<title>NASA Administrator Bill Nelson: \"You Need Both Russians and Americans to Operate the Space Station\"</title>\n<link>https://www.spiegel.de/international/nasa-administrator-bill-nelson-you-need-both-russians-and-americans-to-operate-the-space-station-a-1c5f4b2c-90aa-4290-a442-f519dadf317e#ref=rss</link>\n<description>Confrontation on Earth, cooperation in space – is that justifiable after the Russian invasion of Ukraine? In an interview, NASA Administrator Bill Nelson explains why it is, and also discusses the prospects of putting a European on the Moon.</description>\n<enclosure type=\"image/jpeg\" url=\"https://cdn.prod.www.spiegel.de/images/ebacf381-3b0c-4a88-b8c3-5ebf8aa6802a_w520_r2.08_fpx49.38_fpy50.jpg\"/>\n<guid>https://www.spiegel.de/international/nasa-administrator-bill-nelson-you-need-both-russians-and-americans-to-operate-the-space-station-a-1c5f4b2c-90aa-4290-a442-f519dadf317e</guid>\n<pubDate>Mon, 4 Jul 2022 16:27:10 +0200</pubDate>\n<content:encoded>Confrontation on Earth, cooperation in space – is that justifiable after the Russian invasion of Ukraine? In an interview, NASA Administrator Bill Nelson explains why it is, and also discusses the prospects of putting a European on the Moon.</content:encoded>\n</item>\n<item>\n<title>How Well Are European Sanctions Against Russia Working?</title>\n<link>https://www.spiegel.de/international/europe/how-well-are-european-sanctions-against-russia-working-a-2c83502d-e64f-43a7-98c8-a8076e5746fc#ref=rss</link>\n<description>The European Union spent months preparing comprehensive sanctions against Russia in the event of an invasion of Ukraine. The measures are deeper than anything ever passed before in Brussels, but are they working?</description>\n<enclosure type=\"image/jpeg\" url=\"https://cdn.prod.www.spiegel.de/images/ee751375-73db-4906-8bf6-527c9c948fb1_w520_r2.08_fpx52_fpy66.jpg\"/>\n<guid>https://www.spiegel.de/international/europe/how-well-are-european-sanctions-against-russia-working-a-2c83502d-e64f-43a7-98c8-a8076e5746fc</guid>\n<pubDate>Fri, 1 Jul 2022 18:30:53 +0200</pubDate>\n<content:encoded>The European Union spent months preparing comprehensive sanctions against Russia in the event of an invasion of Ukraine. The measures are deeper than anything ever passed before in Brussels, but are they working?</content:encoded>\n</item>\n<item>\n<title>EU Sanctions: Commission to Allow Russia to Resume Transports to Kaliningrad</title>\n<link>https://www.spiegel.de/international/europe/eu-sanctions-commission-to-allow-russia-to-resume-transports-to-kaliningrad-a-8c779e97-56cb-4dd4-84bd-e3f70de541b2#ref=rss</link>\n<description>The European Commission plans to issue a clarification that will allow Russia to resume sending supplies to the exclave of Kaliningrad via Lithuania. Berlin supports the idea, but some in Vilnius are not pleased.</description>\n<enclosure type=\"image/jpeg\" url=\"https://cdn.prod.www.spiegel.de/images/12df2fc5-9541-42e1-b7b5-07e8ac8e9012_w520_r2.08_fpx52.83_fpy49.99.jpg\"/>\n<guid>https://www.spiegel.de/international/europe/eu-sanctions-commission-to-allow-russia-to-resume-transports-to-kaliningrad-a-8c779e97-56cb-4dd4-84bd-e3f70de541b2</guid>\n<pubDate>Fri, 1 Jul 2022 17:32:00 +0200</pubDate>\n<content:encoded>The European Commission plans to issue a clarification that will allow Russia to resume sending supplies to the exclave of Kaliningrad via Lithuania. Berlin supports the idea, but some in Vilnius are not pleased.</content:encoded>\n</item>\n<item>\n<title>Systematic Abuses at EU External Border: Greek Police Coerce Refugees to Commit Illegal Pushbacks</title>\n<link>https://www.spiegel.de/international/europe/systematic-abuses-at-eu-external-border-greek-police-coerce-refugees-to-commit-illegal-pushbacks-a-32988662-06c8-420d-a2c9-fde426bef1b1#ref=rss</link>\n<description>New reporting exposes how Greek police are exploiting refugees to engage in illegal pushbacks of other would-be asylum-seekers at the EU’s external border. Witness testimony, satellite images and other documents provide evidence of how officials are taking advantage of people seeking protection.</description>\n<enclosure type=\"image/png\" url=\"https://cdn.prod.www.spiegel.de/images/95e44bf7-3b72-4aa5-87c6-0b83d9517388_w520_r2.08_fpx36.09_fpy50.png\"/>\n<guid>https://www.spiegel.de/international/europe/systematic-abuses-at-eu-external-border-greek-police-coerce-refugees-to-commit-illegal-pushbacks-a-32988662-06c8-420d-a2c9-fde426bef1b1</guid>\n<pubDate>Thu, 30 Jun 2022 10:54:42 +0200</pubDate>\n<content:encoded>New reporting exposes how Greek police are exploiting refugees to engage in illegal pushbacks of other would-be asylum-seekers at the EU’s external border. Witness testimony, satellite images and other documents provide evidence of how officials are taking advantage of people seeking protection.</content:encoded>\n</item>\n<item>\n<title>Anatomy of Germany\'s Reliance on Russian Natural Gas: Decades of Addiction</title>\n<link>https://www.spiegel.de/international/business/anatomy-of-germany-s-reliance-on-russian-natural-gas-decades-of-addiction-a-ad156813-3b24-424f-a51e-3ffbd7b6385c#ref=rss</link>\n<description>The Americans warned Germany, as did the Eastern Europeans. But Germany just continued buying more and more natural gas from Russia. The addiction stretches back several decades, and it is full of misjudgments and errors.</description>\n<enclosure type=\"image/jpeg\" url=\"https://cdn.prod.www.spiegel.de/images/73045b6a-2110-4e4f-bd45-6abffb2690ec_w520_r2.08_fpx52.33_fpy44.96.jpg\"/>\n<guid>https://www.spiegel.de/international/business/anatomy-of-germany-s-reliance-on-russian-natural-gas-decades-of-addiction-a-ad156813-3b24-424f-a51e-3ffbd7b6385c</guid>\n<pubDate>Wed, 29 Jun 2022 11:36:35 +0200</pubDate>\n<content:encoded>The Americans warned Germany, as did the Eastern Europeans. But Germany just continued buying more and more natural gas from Russia. The addiction stretches back several decades, and it is full of misjudgments and errors.</content:encoded>\n</item>\n<item>\n<title>New York Times Editor Joe Kahn on Donald Trump and Fox News</title>\n<link>https://www.spiegel.de/international/world/new-york-times-editor-kahn-on-trump-and-fox-news-a-617e9fd9-d51d-4012-b949-5d84d4b7a03a#ref=rss</link>\n<description>In an interview, recently appointed New York Times Executive Editor Joe Kahn talks about how Donald Trump\'s disinformation campaign is gaining steam, discusses the media outlets he considers to be his newspaper\'s competition – and explains why he advises journalists against battles on Twitter.</description>\n<enclosure type=\"image/jpeg\" url=\"https://cdn.prod.www.spiegel.de/images/786724c9-289f-4d19-a81c-9895533cf965_w520_r2.08_fpx56_fpy43.jpg\"/>\n<guid>https://www.spiegel.de/international/world/new-york-times-editor-kahn-on-trump-and-fox-news-a-617e9fd9-d51d-4012-b949-5d84d4b7a03a</guid>\n<pubDate>Tue, 28 Jun 2022 15:53:08 +0200</pubDate>\n<content:encoded>In an interview, recently appointed New York Times Executive Editor Joe Kahn talks about how Donald Trump\'s disinformation campaign is gaining steam, discusses the media outlets he considers to be his newspaper\'s competition – and explains why he advises journalists against battles on Twitter.</content:encoded>\n</item>\n<item>\n<title>German Virologist Christian Drosten on the Battle Against COVID: \"In the Worst Case, It Could Take a Few More Winters\"</title>\n<link>https://www.spiegel.de/international/world/german-virologist-christian-drosten-on-the-battle-against-covid-in-the-worst-case-it-could-take-a-few-more-winters-a-04e022dd-fc78-4917-8083-873d13359bd4#ref=rss</link>\n<description>In an interview, leading German virologist Christian Drosten discusses his concerns about a major new wave of COVID-19 this winter, his own mistakes in the pandemic and the reasons he distanced himself from a government committee convened to battle the disease.</description>\n<enclosure type=\"image/jpeg\" url=\"https://cdn.prod.www.spiegel.de/images/652c9772-8a01-441e-8161-a82f42d11dc0_w520_r2.08_fpx50.24_fpy44.98.jpg\"/>\n<guid>https://www.spiegel.de/international/world/german-virologist-christian-drosten-on-the-battle-against-covid-in-the-worst-case-it-could-take-a-few-more-winters-a-04e022dd-fc78-4917-8083-873d13359bd4</guid>\n<pubDate>Fri, 24 Jun 2022 15:09:46 +0200</pubDate>\n<content:encoded>In an interview, leading German virologist Christian Drosten discusses his concerns about a major new wave of COVID-19 this winter, his own mistakes in the pandemic and the reasons he distanced himself from a government committee convened to battle the disease.</content:encoded>\n</item>\n<item>\n<title>German Economy Minister on the Gas Shortage: \"There Is a Black Hat, and Putin Is Wearing It\"</title>\n<link>https://www.spiegel.de/international/germany/german-economy-minister-on-the-gas-shortage-there-is-a-black-hat-and-putin-is-wearing-it-a-e387bacf-70ce-447f-b7dc-3b48d0ac4178#ref=rss</link>\n<description>Germany is facing a potentially difficult winter due to natural gas shortages. In an interview, German Economy Minister Robert Habeck talks about what Putin is trying to achieve and how Germany is seeking to dull the effects.</description>\n<enclosure type=\"image/jpeg\" url=\"https://cdn.prod.www.spiegel.de/images/5444dd70-be4d-416e-8556-89ce24ce5d86_w520_r2.08_fpx44.99_fpy33.75.jpg\"/>\n<guid>https://www.spiegel.de/international/germany/german-economy-minister-on-the-gas-shortage-there-is-a-black-hat-and-putin-is-wearing-it-a-e387bacf-70ce-447f-b7dc-3b48d0ac4178</guid>\n<pubDate>Fri, 24 Jun 2022 14:40:08 +0200</pubDate>\n<content:encoded>Germany is facing a potentially difficult winter due to natural gas shortages. In an interview, German Economy Minister Robert Habeck talks about what Putin is trying to achieve and how Germany is seeking to dull the effects.</content:encoded>\n</item>\n<item>\n<title>Spotlight on Germany\'s Colonial Past: When Can Ngonnso Return Home?</title>\n<link>https://www.spiegel.de/international/germany/spotlight-on-germany-s-colonial-past-when-can-ngonnso-return-home-a-a2ab356d-538f-4ae7-b452-82060382e2c7#ref=rss</link>\n<description>The Ethnological Museum in Berlin is home to a statue called Ngonnso, taken from her home by German colonialists at the beginning of the 20th century. A tribe in Cameroon has been demanding her return for decades. And now, they may finally be granted their wish.</description>\n<enclosure type=\"image/png\" url=\"https://cdn.prod.www.spiegel.de/images/6b2182cd-e808-432f-9efb-6c0f4fe30da1_w520_r2.08_fpx49_fpy40.png\"/>\n<guid>https://www.spiegel.de/international/germany/spotlight-on-germany-s-colonial-past-when-can-ngonnso-return-home-a-a2ab356d-538f-4ae7-b452-82060382e2c7</guid>\n<pubDate>Thu, 23 Jun 2022 18:55:22 +0200</pubDate>\n<content:encoded>The Ethnological Museum in Berlin is home to a statue called Ngonnso, taken from her home by German colonialists at the beginning of the 20th century. A tribe in Cameroon has been demanding her return for decades. And now, they may finally be granted their wish.</content:encoded>\n</item>\n<item>\n<title>Interview with Latvian Prime Minister: \"Putin Is On His Own Trajectory Regardless of What the EU Does\"</title>\n<link>https://www.spiegel.de/international/europe/interview-with-latvian-prime-minister-putin-is-on-his-own-trajectory-regardless-of-what-the-eu-does-a-1c0e36d0-e398-4715-8645-012638191797#ref=rss</link>\n<description>Should Ukraine be granted candidate status for the European Union? Latvian Prime Minister Krišjānis Kariņš says that Putin\'s war means there is no longer a middle path for Eastern Europe. Either countries join the EU or they become part of the Russian empire.</description>\n<enclosure type=\"image/jpeg\" url=\"https://cdn.prod.www.spiegel.de/images/f689537c-834c-4bf2-ae82-bbfa7b085dff_w520_r2.08_fpx65.76_fpy45.jpg\"/>\n<guid>https://www.spiegel.de/international/europe/interview-with-latvian-prime-minister-putin-is-on-his-own-trajectory-regardless-of-what-the-eu-does-a-1c0e36d0-e398-4715-8645-012638191797</guid>\n<pubDate>Thu, 23 Jun 2022 18:27:12 +0200</pubDate>\n<content:encoded>Should Ukraine be granted candidate status for the European Union? Latvian Prime Minister Krišjānis Kariņš says that Putin\'s war means there is no longer a middle path for Eastern Europe. Either countries join the EU or they become part of the Russian empire.</content:encoded>\n</item>\n<item>\n<title>Kyiv Reawakens: Life Slowly Comes Back to Ukraine\'s Capital</title>\n<link>https://www.spiegel.de/international/world/kyiv-reawakens-life-slowly-comes-back-to-ukraine-s-capital-a-8c05afec-77da-41c8-ab2f-a59bb904f22c#ref=rss</link>\n<description>The cafés are open, restaurants are booked up and the squares are full of people. After months of fear, residents of Kyiv are slowly resuming their old lives. But it\'s harder than it may seem. A walk through the traumatized Ukrainian capital.</description>\n<enclosure type=\"image/jpeg\" url=\"https://cdn.prod.www.spiegel.de/images/9b27d7b9-0748-4228-8f86-052db2cd0f84_w520_r2.08_fpx36_fpy53.jpg\"/>\n<guid>https://www.spiegel.de/international/world/kyiv-reawakens-life-slowly-comes-back-to-ukraine-s-capital-a-8c05afec-77da-41c8-ab2f-a59bb904f22c</guid>\n<pubDate>Thu, 23 Jun 2022 18:24:41 +0200</pubDate>\n<content:encoded>The cafés are open, restaurants are booked up and the squares are full of people. After months of fear, residents of Kyiv are slowly resuming their old lives. But it\'s harder than it may seem. A walk through the traumatized Ukrainian capital.</content:encoded>\n</item>\n<item>\n<title>Syrian Drug Smuggling: \"The Assad Regime Would Not Survive Loss of Captagon Revenues\"</title>\n<link>https://www.spiegel.de/international/world/syrian-drug-smuggling-the-assad-regime-would-not-survive-loss-of-captagon-revenues-a-b4302356-e562-4088-95a1-45d557a3952a#ref=rss</link>\n<description>The regime of Bashar Assad is apparently deeply involved in the trade of synthetic drugs. German investigators have now found proof that Syria\'s dictator is apparently funding his rule with drug money.</description>\n<enclosure type=\"image/jpeg\" url=\"https://cdn.prod.www.spiegel.de/images/640e4a7d-fbdf-4a4d-816f-4abb86744e3d_w520_r2.08_fpx36.02_fpy50.jpg\"/>\n<guid>https://www.spiegel.de/international/world/syrian-drug-smuggling-the-assad-regime-would-not-survive-loss-of-captagon-revenues-a-b4302356-e562-4088-95a1-45d557a3952a</guid>\n<pubDate>Tue, 21 Jun 2022 15:05:12 +0200</pubDate>\n<content:encoded>The regime of Bashar Assad is apparently deeply involved in the trade of synthetic drugs. German investigators have now found proof that Syria\'s dictator is apparently funding his rule with drug money.</content:encoded>\n</item>\n<item>\n<title>Searching for the Final Suspects of the Rwandan Genocide</title>\n<link>https://www.spiegel.de/international/world/searching-for-the-final-suspects-of-the-rwandan-genocide-a-c8438dd7-a59c-43a8-85d8-74348f38e400#ref=rss</link>\n<description>In 1994, Hutu extremists slaughtered 800,000 Tutsi using nail-spiked clubs, machetes and other weapons. A UN unit led by Chief Prosecutor Serge Brammertz is still trying to track down those responsible, but it is a race against time.</description>\n<enclosure type=\"image/jpeg\" url=\"https://cdn.prod.www.spiegel.de/images/72369194-5609-49a1-bfa3-342b8afb5313_w520_r2.08_fpx33.32_fpy49.99.jpg\"/>\n<guid>https://www.spiegel.de/international/world/searching-for-the-final-suspects-of-the-rwandan-genocide-a-c8438dd7-a59c-43a8-85d8-74348f38e400</guid>\n<pubDate>Mon, 20 Jun 2022 17:15:09 +0200</pubDate>\n<content:encoded>In 1994, Hutu extremists slaughtered 800,000 Tutsi using nail-spiked clubs, machetes and other weapons. A UN unit led by Chief Prosecutor Serge Brammertz is still trying to track down those responsible, but it is a race against time.</content:encoded>\n</item>\n<item>\n<title>Senior U.S. Diplomat on the War in Ukraine: Kyiv Is \"Rightly Demanding More\"</title>\n<link>https://www.spiegel.de/international/world/senior-u-s-diplomat-on-the-war-in-ukraine-kyiv-is-rightly-demanding-more-a-6389ff3b-0170-4965-bce9-7ff16f920dc9#ref=rss</link>\n<description>In an interview, American diplomat Karen Donfried expresses her concern about Russia\'s advances in the Donbas and her approval of German Chancellor Scholz\'s pledges to provide more military aid to Kyiv and increase Berlin\'s own defense spending. She says Washington also supports EU membership for Ukraine.</description>\n<enclosure type=\"image/jpeg\" url=\"https://cdn.prod.www.spiegel.de/images/309b2778-9dfb-4788-b787-82eb720066c9_w520_r2.08_fpx49.99_fpy42.83.jpg\"/>\n<guid>https://www.spiegel.de/international/world/senior-u-s-diplomat-on-the-war-in-ukraine-kyiv-is-rightly-demanding-more-a-6389ff3b-0170-4965-bce9-7ff16f920dc9</guid>\n<pubDate>Mon, 20 Jun 2022 14:57:47 +0200</pubDate>\n<content:encoded>In an interview, American diplomat Karen Donfried expresses her concern about Russia\'s advances in the Donbas and her approval of German Chancellor Scholz\'s pledges to provide more military aid to Kyiv and increase Berlin\'s own defense spending. She says Washington also supports EU membership for Ukraine.</content:encoded>\n</item>\n<item>\n<title>Accelerated Candidacy?: Ukraine\'s Possible EU Accession Not Universally Welcome</title>\n<link>https://www.spiegel.de/international/europe/accelerated-candidacy-ukraine-s-possible-eu-accession-not-universally-welcome-a-b7504043-0cb7-4d38-b7f5-a963fb195429#ref=rss</link>\n<description>Ukrainian President Volodymyr Zelenskyy wants his country to become an EU member as rapidly as possible. But no all countries in the bloc are supportive of the idea. And potential members in the Balkans that have been waiting for years for the privilege are losing their patience.</description>\n<enclosure type=\"image/jpeg\" url=\"https://cdn.prod.www.spiegel.de/images/857dd0cd-800c-4100-b0e7-e7ae8387ec1f_w520_r2.08_fpx53_fpy44.jpg\"/>\n<guid>https://www.spiegel.de/international/europe/accelerated-candidacy-ukraine-s-possible-eu-accession-not-universally-welcome-a-b7504043-0cb7-4d38-b7f5-a963fb195429</guid>\n<pubDate>Fri, 17 Jun 2022 17:45:09 +0200</pubDate>\n<content:encoded>Ukrainian President Volodymyr Zelenskyy wants his country to become an EU member as rapidly as possible. But no all countries in the bloc are supportive of the idea. And potential members in the Balkans that have been waiting for years for the privilege are losing their patience.</content:encoded>\n</item>\n<item>\n<title>Ukraine By Rail: The Trains Keep Running Despite the War</title>\n<link>https://www.spiegel.de/international/world/ukraine-by-rail-the-trains-keep-running-despite-the-war-a-62b70c28-a783-43ce-8137-c6c46e44473b#ref=rss</link>\n<description>DER SPIEGEL reporters have been traveling across Ukraine for months reporting on the war, mostly by train. As they have navigated the country\'s vast rail network, they frequently experience stories of terror and flight, courage and defiance.</description>\n<enclosure type=\"image/jpeg\" url=\"https://cdn.prod.www.spiegel.de/images/7a64c7cc-6877-46d9-a0f9-7b78b0fcaffd_w520_r2.08_fpx51_fpy50.jpg\"/>\n<guid>https://www.spiegel.de/international/world/ukraine-by-rail-the-trains-keep-running-despite-the-war-a-62b70c28-a783-43ce-8137-c6c46e44473b</guid>\n<pubDate>Fri, 17 Jun 2022 16:48:48 +0200</pubDate>\n<content:encoded>DER SPIEGEL reporters have been traveling across Ukraine for months reporting on the war, mostly by train. As they have navigated the country\'s vast rail network, they frequently experience stories of terror and flight, courage and defiance.</content:encoded>\n</item>\n<item>\n<title>High Casualties: Russia Pulls Out All the Stops to Find Fresh Troops</title>\n<link>https://www.spiegel.de/international/world/high-casualties-russia-pulls-out-all-the-stops-to-find-fresh-troops-a-254bf9c2-c83b-4492-8dea-1f5cec53b03e#ref=rss</link>\n<description>The Russian army is suffering high casualties in the war against Ukraine and Vladimir Putin badly needs fresh troops. He wants to avoid a general mobilization, so the military is relying on other methods.</description>\n<enclosure type=\"image/jpeg\" url=\"https://cdn.prod.www.spiegel.de/images/cafb060f-9a2f-4e37-a9de-fdc13c7f947e_w520_r2.08_fpx39_fpy39.jpg\"/>\n<guid>https://www.spiegel.de/international/world/high-casualties-russia-pulls-out-all-the-stops-to-find-fresh-troops-a-254bf9c2-c83b-4492-8dea-1f5cec53b03e</guid>\n<pubDate>Wed, 15 Jun 2022 12:08:39 +0200</pubDate>\n<content:encoded>The Russian army is suffering high casualties in the war against Ukraine and Vladimir Putin badly needs fresh troops. He wants to avoid a general mobilization, so the military is relying on other methods.</content:encoded>\n</item>\n<item>\n<title>The Artillery War in the Donbas: Ukraine Relying Heavily on Heavy Weapons from the West</title>\n<link>https://www.spiegel.de/international/world/the-artillery-war-in-the-donbas-ukraine-relying-heavily-on-heavy-weapons-from-the-west-a-547f2619-959b-41df-8458-a4c66ee50556#ref=rss</link>\n<description>The war in Ukraine has morphed into an artillery battle, with Kyiv even more reliant than ever on heavy weaponry from the West. The country no longer has high hopes for significant support from Germany.</description>\n<enclosure type=\"image/jpeg\" url=\"https://cdn.prod.www.spiegel.de/images/dc4603bd-c38d-4eaa-b73f-b95b01b57108_w520_r2.08_fpx61.71_fpy52.97.jpg\"/>\n<guid>https://www.spiegel.de/international/world/the-artillery-war-in-the-donbas-ukraine-relying-heavily-on-heavy-weapons-from-the-west-a-547f2619-959b-41df-8458-a4c66ee50556</guid>\n<pubDate>Fri, 10 Jun 2022 21:29:15 +0200</pubDate>\n<content:encoded>The war in Ukraine has morphed into an artillery battle, with Kyiv even more reliant than ever on heavy weaponry from the West. The country no longer has high hopes for significant support from Germany.</content:encoded>\n</item>\n</channel>\n</rss>
"""
