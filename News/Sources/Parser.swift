import Foundation

final class Parser: NSObject, XMLParserDelegate {
    private(set) var result = ""
    private var finished: (() -> Void)?
    private var fail: ((Error) -> Void)?
    private var content = ""

    init(html: String) async throws {
        super.init()
        
        result = try await withUnsafeThrowingContinuation { [weak self] continuation in
            let clean = html
                .replacingOccurrences(of: "<br><br>",
                                      with: "<br>",
                                      options: .caseInsensitive)
                .replacingOccurrences(of: "<hr><hr>",
                                      with: "<hr>",
                                      options: .caseInsensitive)
                .replacingOccurrences(of: "<br>",
                                      with: "\n",
                                      options: .caseInsensitive)
                .replacingOccurrences(of: "<hr>",
                                      with: "\n",
                                      options: .caseInsensitive)
                .replacingOccurrences(of: "<p>",
                                      with: "",
                                      options: .caseInsensitive)
                .replacingOccurrences(of: "</p>",
                                      with: "\n",
                                      options: .caseInsensitive)
                .replacingOccurrences(of: "<li>",
                                      with: "\n",
                                      options: .caseInsensitive)
                .replacingOccurrences(of: "\n\n",
                                      with: "\n",
                                      options: .caseInsensitive)
            
            let xml = XMLParser(data: .init(("<xml>" + clean + "</xml>").utf8))
            self?.finished = { [weak self] in
                xml.delegate = nil
                self?.fail = nil
                self?.finished = nil
                
                guard let content = self?.content else { return }
                
                continuation
                    .resume(returning: content
                        .trimmingCharacters(in:
                                .whitespacesAndNewlines))
            }
            
            self?.fail = { [weak self] in
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
        }
    }
    
    func parserDidEndDocument(_: XMLParser) {
        finished?()
    }
    
    func parser(_: XMLParser, parseErrorOccurred: Error) {
        fail?(parseErrorOccurred)
    }
    
    func parser(_: XMLParser, validationErrorOccurred: Error) {
        fail?(validationErrorOccurred)
    }
    
    func parser(_: XMLParser, foundCharacters: String) {
        content += foundCharacters
    }
    
    deinit {
        print("contnet gone")
    }
}
