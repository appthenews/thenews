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
}
