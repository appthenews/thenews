import Foundation

struct Fetch {
    private let session: URLSession
    private let date: Date.ParseStrategy
    
    init() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 6
        configuration.timeoutIntervalForResource = 6
        configuration.waitsForConnectivity = true
        configuration.allowsCellularAccess = true
        session = .init(configuration: configuration)
        
        date = .init(
            format: """
\(weekday: .short), \(day: .defaultDigits) \(month: .defaultDigits) \(year: .defaultDigits) \(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits) \(timeZone: .genericLocation)
""",
            locale: .init(identifier: "en_US"),
            timeZone: .current
        )
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
            .compactMap {
                $0.item(strategy: date)
            } ?? []
        
        print(items)
        
        return ""
    }
}
