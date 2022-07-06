import Foundation

extension XMLNode {
    func item(strategy: Date.ParseStrategy) -> Item? {
        guard
            name == "item",
            let guid = element(name: "guid"),
            let title = element(name: "title"),
            let pubDate = element(name: "pubDate"),
            let description = element(name: "description"),
            let link = element(name: "link"),
            let date = try? Date(pubDate, strategy: strategy)
        else { return nil }
        
        return .init(title: title,
                     date: date)
    }
    
    private func element(name: String) -> String? {
        children?
            .first { $0.name == name }?
            .stringValue
    }
}

