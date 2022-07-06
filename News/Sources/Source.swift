import Foundation

public enum Source: UInt8, CaseIterable {
    case
    theGuardianWorld,
    theGuardianGermany,
    reutersInternational,
    reutersEurope,
    derSpiegelInternational,
    theLocalInternational,
    theLocalGermany
    
    public var provider: Provider {
        switch self {
        case .theGuardianWorld,
                .theGuardianGermany:
            return .theGuardian
        case .reutersInternational,
                .reutersEurope:
            return .reuters
        case .derSpiegelInternational:
            return .derSpiegel
        case .theLocalInternational,
                .theLocalGermany:
            return .theLocal
        }
    }
    
    var url: URL {
        .init(string: path)!
    }
    
    private var path: String {
        switch self {
        case .theGuardianWorld:
            return "https://www.theguardian.com/world/rss"
        case .theGuardianGermany:
            return "www.theguardian.com/world/germany/rss"
        case .reutersInternational:
            return "www.reutersagency.com/feed/?taxonomy=best-regions&post_type=best"
        case .reutersEurope:
            return "www.reutersagency.com/feed/?best-regions=europe&post_type=best"
        case .derSpiegelInternational:
            return "https://www.spiegel.de/international/index.rss"
        case .theLocalInternational:
            return "https://feeds.thelocal.com/rss/international"
        case .theLocalGermany:
            return "https://feeds.thelocal.com/rss/de"
        }
    }
}
