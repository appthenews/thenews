public enum Provider {
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
    
    var sources: [Source] {
        switch self {
        case .all:
            return Source.allCases
        default:
            return Source
                .allCases
                .filter {
                    $0.provider == self
                }
        }
    }
}
