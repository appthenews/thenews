import Foundation

extension XMLNode {
    func item(feed: Feed, strategy: Date.ParseStrategy, synched: Set<String>) -> (id: String, item: Item)? {
        guard
            name == "item",
            let guid = self["guid"]?.max8,
            !synched.contains(guid),
            let title = self["title"]?.max8,
            let pubDate = self["pubDate"],
            let description = self["description"],
            let link = self["link"]?.max8,
            let date = try? Date(pubDate, strategy: strategy)
        else { return nil }
        lol()
        return (id: guid,
                item: .init(feed: feed,
                            title: title,
                            description: description,
                            link: link,
                            date: date,
                            synched: .now,
                            status: .new))
    }
    
    private subscript(_ name: String) -> String? {
        children?
            .first { $0.name == name }?
            .stringValue
    }
    
    private func lol() {
        
        let asd = """
<p>Reuters revealed that Germany and Qatar have hit difficulties in talks over long-term liquefied natural gas (LNG) supply deals amid differences over [&#8230;]</p>\n<p>The post <a rel=\"nofollow\" href=\"https://www.reutersagency.com/en/reutersbest/article/reuters-reveals-germany-qatar-at-odds-over-terms-in-talks-on-lng-supply-deal/\">Reuters reveals Germany, Qatar at odds over terms in talks on LNG supply deal</a> appeared first on <a rel=\"nofollow\" href=\"https://www.reutersagency.com/en/\">Reuters News Agency</a>.</p>\n
"""
        
//        let a = try! XMLDocument(data: .init(("<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + asd).utf8))
        
        debugPrint("my html <a href=\"\">link text</a>".removingHTML)
    }
}


extension String {
    var removingHTML: Self? {
        let removingDocType = replacingOccurrences(of: "<!DOCTYPE html>", with: "")
        let wrapped = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><root>" + removingDocType + "</root>"
        guard let xml = try? XMLDocument(data: .init(wrapped.utf8)) else { return nil }
        var children = xml.rootDocument?.children?.first?.children
        while children?.first?.name?.lowercased() == "html"
                || children?.first?.name?.lowercased() == "body" {
            children = children?.first?.children
        }
        return children
            .flatMap {
                $0.compactMap(\.stringValue)
            }?
            .joined(separator: "\n")
    }
}
