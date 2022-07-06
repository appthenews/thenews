import Foundation

struct Fetcher {
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
\(weekday: .short), \
\(day: .defaultDigits) \
\(month: .defaultDigits) \
\(year: .defaultDigits) \
\(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\
\(minute: .twoDigits):\
\(second: .twoDigits) \
\(timeZone: .genericLocation)
""",
            locale: .init(identifier: "en_US"),
            timeZone: .current
        )
    }
    
    func fetch(source: Source, synched: Set<String>) async throws -> (ids: Set<String>, items: Set<Item>) {
        let (data, response) = try await session.data(from: source.url)

        guard (response as? HTTPURLResponse)?.statusCode == 200, !data.isEmpty
        else { throw NSError(domain: "", code: 0) }
        
        return try parse(data: data, synched: synched)
    }
    
    func parse(data: Data, synched: Set<String>) throws -> (ids: Set<String>, items: Set<Item>) {
        let document = try XMLDocument(data: data)
        
        let result: [(id: String, item: Item)] =
        document
            .rootElement()?
            .children?
            .first?
            .children?
            .compactMap {
                $0.item(strategy: date, synched: synched)
            } ?? []
        
        return (ids: .init(result.map(\.id)), items: .init(result.map(\.item)))
    }
}
