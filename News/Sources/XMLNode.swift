import Foundation

extension XMLNode {
    func item(strategy: Date.ParseStrategy) -> Item? {
        guard
            name == "item",
            let guid = element(name: "guid")?.max8,
            let title = element(name: "title")?.max8,
            let pubDate = element(name: "pubDate"),
            let description = element(name: "description"),
            let link = element(name: "link")?.max8,
            let date = try? Date(pubDate, strategy: strategy)
        else { return nil }
        
        return .init(title: title,
                     description: description,
                     link: link,
                     date: date)
    }
    
    private func element(name: String) -> String? {
        children?
            .first { $0.name == name }?
            .stringValue
    }
}

