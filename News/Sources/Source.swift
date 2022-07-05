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
}
