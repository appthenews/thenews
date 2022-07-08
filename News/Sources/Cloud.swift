import Archivable

extension Cloud where Output == Archive {
    public func fetch() async {
        do {
            let fetchable = model.fetchable
            
            if !fetchable.isEmpty {
                model.clean()
                
                let fetcher = Fetcher()
                for feed in fetchable {
                    let result = try await fetcher.fetch(feed: feed, synched: model.ids)
                    model.update(feed: feed, date: .now, ids: result.ids, items: result.items)
                }
                
                await stream()
            }
        } catch { }
    }
    
    public func toggle(feed: Feed, value: Bool) async {
        model.preferences.feeds[feed] = value
        
        await fetch()
        await stream()
    }
    
    public func read(item: Item) async {
        model.update(item: item.read)
        await stream()
    }
    
    public func bookmarked(item: Item) async {
        model.update(item: item.bookmarked)
        await stream()
    }
}
