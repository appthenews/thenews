import Archivable

extension Cloud where Output == Archive {
    public func fetch() async {
        do {
            var fetcher: Fetcher!
            for source in model.fetchable {
                if fetcher == nil {
                    fetcher = .init()
                }
                
                let synched = model.history[source]!.ids
                let result = try await fetcher.fetch(source: source, synched: synched)
                model.history[source] = model
                    .history[source]!
                    .update(cleaning: model.preferences.delete,
                            adding: result.ids,
                            and: result.items)
            }
            
            if fetcher != nil {
                await stream()
            }
        } catch { }
    }
    
    public func read(source: Source, item: Item) async {
        model.history[source] = model.history[source]!.read(item: item)
        await stream()
    }
    
    public func bookmarked(source: Source, item: Item) async {
        model.history[source] = model.history[source]!.bookmarked(item: item)
        await stream()
    }
}
