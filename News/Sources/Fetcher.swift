import Foundation

struct Fetcher {
    private let session: URLSession
    private let date: Date.ParseStrategy
    
    init() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 3
        configuration.timeoutIntervalForResource = 3
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
    
    func fetch(feed: Feed) async throws -> Set<Item> {
        let (data, response) = try await session.data(from: feed.url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200, !data.isEmpty
        else { throw NSError(domain: "", code: 0) }
        
        return try await parse(feed: feed, data: data)
    }
    
    func parse(feed: Feed, data: Data) async throws -> Set<Item> {
        try await XML(feed: feed, strategy: date, data: data).items
    }
}
