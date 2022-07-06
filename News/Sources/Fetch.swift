import Foundation

struct Fetch {
    private let session: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 6
        configuration.timeoutIntervalForResource = 6
        configuration.waitsForConnectivity = true
        configuration.allowsCellularAccess = true
        session = .init(configuration: configuration)
    }
    
    func callAsFunction(_ source: Source) async throws -> String {
        let (data, response) = try await session.data(from: source.url)

        guard (response as? HTTPURLResponse)?.statusCode == 200, !data.isEmpty
        else { throw NSError(domain: "", code: 0) }
        
        let document = try XMLDocument(data: data)
//        print(doc)
        
        print(document
            .rootElement()?
            .children?
            .first?
            .children?
            .filter {
                $0.name == "item"
            }
            .first)
        
        let items: [Item] =
        document
            .rootElement()?
            .children?
            .first?
            .children?
            .filter {
                $0.name == "item"
            }
            .compactMap(\.children)
            .compactMap {
                guard
                    let title = $0.first(where: { $0.name == "title" })?.stringValue,
                    !title.isEmpty
                else { return nil }
                return Item(title: title)
            } ?? []
        
        print(items)
        
        return ""
    }
}
