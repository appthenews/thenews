public enum Provider: UInt8, CaseIterable {
    case
    all,
    theGuardian,
    reuters,
    derSpiegel,
    theLocal
    
    public var title: String {
        switch self {
        case .all:
            return "All feeds"
        case .theGuardian:
            return "The Guardian"
        case .reuters:
            return "Reuters"
        case .derSpiegel:
            return "Der Spiegel"
        case .theLocal:
            return "The Local"
        }
    }
}
