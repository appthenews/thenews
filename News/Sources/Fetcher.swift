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
    
    func fetch(feed: Feed, synched: Set<String>) async throws -> (ids: Set<String>, items: Set<Item>) {
        let (data, response) = try await session.data(from: feed.url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200, !data.isEmpty
        else { throw NSError(domain: "", code: 0) }
        
        return try await parse(feed: feed, data: data, synched: synched)
    }
}
    
#if os(macOS)
extension Fetcher {
    func parse(feed: Feed, data: Data, synched: Set<String>) async throws -> (ids: Set<String>, items: Set<Item>) {
        let document = try XMLDocument(data: data)
        
        let result: [(id: String, item: Item)] =
        document
            .rootElement()?
            .children?
            .first?
            .children?
            .compactMap {
                $0.item(feed: feed, strategy: date, synched: synched)
            } ?? []
        
        return (ids: .init(result.map(\.id)), items: .init(result.map(\.item)))
    }
}

private extension XMLNode {
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
        let wrapped = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><xml>" + description + "</xml>"
        guard let xml = try? XMLDocument(data: .init(wrapped.utf8), options: .documentTidyXML) else { return nil }
        return xml
            .rootDocument?
            .children?
            .first?
            .children
            .flatMap {
                $0.compactMap(\.stringValue)
            }?
            .joined(separator: "\n\n")
    }
    
    private subscript(_ name: String) -> String? {
        children?
            .first { $0.name == name }?
            .stringValue
    }
}

#else
extension Fetcher {
    func parse(feed: Feed, data: Data, synched: Set<String>) async throws -> (ids: Set<String>, items: Set<Item>) {
        try await Parser(feed: feed, strategy: date, synched: synched).parse(data: data)
    }
}

private final class Parser: NSObject, XMLParserDelegate {
    private var finished: (() async -> Void)?
    private var fail: ((Error) -> Void)?
    private var ids = Set<String>()
    private var items = Set<Item>()
    private var item: [String : String]?
    private var element: String?
    private var completed = [[String : String]]()
    private let synched: Set<String>
    private let strategy: Date.ParseStrategy
    private let feed: Feed
    
    init(feed: Feed, strategy: Date.ParseStrategy, synched: Set<String>) {
        self.feed = feed
        self.strategy = strategy
        self.synched = synched
    }
    
    func parse(data: Data) async throws -> (ids: Set<String>, items: Set<Item>) {
        try await withUnsafeThrowingContinuation { [weak self] continuation in
            let xml = XMLParser(data: data)
            self?.finished = { [weak self] in
                xml.delegate = nil
                
                guard let self = self else { fatalError() }
                
                for item in self.completed {
                    guard
                        let guid = item["guid"]?.max8,
                        !self.synched.contains(guid),
                        let description = item["description"],
                        let title = item["title"]?.max8,
                        let pubDate = item["pubDate"],
                        let link = item["link"]?.max8,
                        let date = try? Date(pubDate, strategy: self.strategy)
                    else { continue }
                    
                    self.ids.insert(guid)
                    self.items.insert(.init(feed: self.feed,
                                            title: title,
                                            description: description,
                                            link: link,
                                            date: date,
                                            synched: .now,
                                            status: .new))
                }
                
                continuation
                    .resume(returning: (self.ids, self.items))
            }
            
            self?.fail = {
                xml.delegate = self
                continuation.resume(throwing: $0)
            }
            
            xml.delegate = self
            xml.parse()
        }
    }
    
    func parserDidEndDocument(_: XMLParser) {
        Task {
            await finished?()
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred: Error) {
        fail?(parseErrorOccurred)
        parser.abortParsing()
    }
    
    func parser(_ parser: XMLParser, validationErrorOccurred: Error) {
        fail?(validationErrorOccurred)
        parser.abortParsing()
    }
    
    func parser(_: XMLParser, didStartElement: String, namespaceURI: String?, qualifiedName: String?, attributes: [String : String] = [:]) {
        element = ""
        guard didStartElement == "item" else { return }
        item = [:]
    }
    
    func parser(_: XMLParser, didEndElement: String, namespaceURI: String?, qualifiedName: String?) {
        if didEndElement == "item" {
            if let item = item {
                completed.append(item)
                self.item = nil
            }
        } else if item != nil, let element = element {
            item![didEndElement] = element
            self.element = nil
        }
    }
    
    func parser(_: XMLParser, foundCharacters: String) {
        element? += foundCharacters
    }
    
    deinit {
        print("xml gone")
    }
}

private final class Content: NSObject, XMLParserDelegate {
    private var finished: (() -> Void)?
    private var fail: ((Error) -> Void)?
    private var element = ""
    
    func parse(data: Data) async throws -> String {
        try await withUnsafeThrowingContinuation { [weak self] continuation in
            let xml = XMLParser(data: data)
            self?.finished = { [weak self] in
                xml.delegate = nil
                guard let element = self?.element else { return }
                continuation
                    .resume(returning: element)
            }
            
            self?.fail = {
                xml.delegate = self
                continuation.resume(throwing: $0)
            }
            
            xml.delegate = self
            xml.parse()
        }
    }
    
    func parserDidEndDocument(_: XMLParser) {
        finished?()
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred: Error) {
        fail?(parseErrorOccurred)
        parser.abortParsing()
    }
    
    func parser(_ parser: XMLParser, validationErrorOccurred: Error) {
        fail?(validationErrorOccurred)
        parser.abortParsing()
    }
    
    func parser(_: XMLParser, didStartElement: String, namespaceURI: String?, qualifiedName: String?, attributes: [String : String] = [:]) {

    }
    
    func parser(_: XMLParser, didEndElement: String, namespaceURI: String?, qualifiedName: String?) {
        
    }
    
    func parser(_: XMLParser, foundCharacters: String) {
        element += foundCharacters
    }
    
    deinit {
        print("contnet gone")
    }
}
#endif
