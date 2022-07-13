extension Array where Element == Item {
    public func filter(search: String) -> Self {
        let components = search
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: " ")
            .filter {
                !$0.isEmpty
            }
        
        return components.isEmpty
        ? self
        : filter { item in
            !components
                .filter { filter in
                    item.title.localizedCaseInsensitiveContains(filter)
                    || item.description.localizedCaseInsensitiveContains(filter)
                    || item.link.localizedCaseInsensitiveContains(filter)
                }
                .isEmpty
        }
    }
}
