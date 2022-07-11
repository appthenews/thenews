import Foundation

extension XMLNode {
    func item(feed: Feed, strategy: Date.ParseStrategy, synched: Set<String>) -> (id: String, item: Item)? {
        guard
            name == "item",
            let guid = self["guid"]?.max8,
            !synched.contains(guid),
            let description = content,
            let title = self["title"]?.max8,
            let pubDate = self["pubDate"],
            let link = self["link"]?.max8,
            let date = try? Date(pubDate, strategy: strategy)
        else { return nil }
        return (id: guid,
                item: .init(feed: feed,
                            title: title,
                            description: description,
                            link: link,
                            date: date,
                            synched: .now,
                            status: .new))
    }
    
    private var content: String? {
        guard let description = self["description"] else { return nil }
        let wrapped = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><root>" + description + "</root>"
        guard let xml = try? XMLDocument(data: .init(wrapped.utf8)) else { return nil }
        return xml
            .rootDocument?
            .children?
            .first?
            .children
            .flatMap {
                $0.compactMap(\.stringValue)
            }?
            .joined(separator: "\n")
    }
    
    private subscript(_ name: String) -> String? {
        children?
            .first { $0.name == name }?
            .stringValue
    }
}
