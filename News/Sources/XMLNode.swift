import Foundation

extension XMLNode {
    func item(feed: Feed, strategy: Date.ParseStrategy, synched: Set<String>) -> (id: String, item: Item)? {
        guard
            name == "item",
            let guid = element(name: "guid")?.max8,
            !synched.contains(guid),
            let title = element(name: "title")?.max8,
            let pubDate = element(name: "pubDate"),
            let description = element(name: "description"),
            let link = element(name: "link")?.max8,
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
    
    private func element(name: String) -> String? {
        children?
            .first { $0.name == name }?
            .stringValue
    }
}
