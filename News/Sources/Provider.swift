public enum Provider {
    case
    all,
    theGuardian,
    reuters,
    derSpiegel,
    theLocal
    
    public var title: String {
        switch provider {
        case .all:
            return "All feeds"
        case .theGuardian:
            text.stringValue = "The Guardian"
        case .reuters:
            text.stringValue = "Reuters"
        case .derSpiegel:
            text.stringValue = title
        case .theLocal:
            text.stringValue = title
        }
    }
}
