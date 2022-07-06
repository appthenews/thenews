import Foundation

public struct Fetcher: Fetch {
    private let session: URLSession
    
    public init() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 6
        configuration.timeoutIntervalForResource = 6
        configuration.waitsForConnectivity = true
        configuration.allowsCellularAccess = true
        session = .init(configuration: configuration)
    }
}
