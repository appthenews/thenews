import Foundation

final class XML: NSObject, XMLParserDelegate {
    private(set) var items = Set<Item>()
    private var finished: (() async -> Void)?
    private var fail: ((Error) -> Void)?
    private var item: [String : String]?
    private var element = ""
    private var completed = [[String : String]]()
    private let strategy: Date.ParseStrategy
    private let feed: Feed
    
    init(feed: Feed,
         strategy: Date.ParseStrategy,
         data: Data) async throws {
        self.feed = feed
        self.strategy = strategy
        
        super.init()
        
        try await withUnsafeThrowingContinuation { [weak self] continuation in
            let xml = XMLParser(data: data)
            self?.finished = { [weak self] in
                xml.delegate = nil
                self?.fail = nil
                self?.finished = nil
                
                guard let self = self else { return }
                
                for item in self.completed {
                    guard
                        let raw = item["description"],
                        let description = try? await Parser(html: raw).result,
                        let title = item["title"]?.max8,
                        let pubDate = item["pubDate"],
                        let link = item["link"]?.max8,
                        let date = try? Date(pubDate, strategy: self.strategy)
                    else { continue }
                    self.items.insert(.init(feed: self.feed,
                                            title: title,
                                            description: description.replacingOccurrences(of: "\n", with: "\n\n"),
                                            link: link,
                                            date: date,
                                            synched: .now,
                                            status: .new))
                }
                
                continuation.resume()
            }
            
            self?.fail = { [weak self] in
                fatalError()
                #warning("here")
                xml.delegate = nil
                self?.fail = nil
                self?.finished = nil
                xml.abortParsing()

                continuation
                    .resume(throwing: $0)
            }
            
            xml.delegate = self
            
            if !xml.parse(),
                let error = xml.parserError {
                self?.fail?(error)
            }
        } as Void
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
        } else if item != nil {
            item![didEndElement] = element
        }
    }
    
    func parser(_: XMLParser, foundCharacters: String) {
        element += foundCharacters
    }
}
