import Foundation

public enum Interval: UInt8 {
    case
    hour,
    hours3,
    hours6,
    hours12,
    day,
    days3,
    week
    
    public var title: String {
        switch self {
        case .hour:
            return "Hour"
        case .hours3:
            return "3 hours"
        case .hours6:
            return "6 hours"
        case .hours12:
            return "12 hours"
        case .day:
            return "Day"
        case .days3:
            return "3 days"
        case .week:
            return "Week"
        }
    }
    
    func passed(date: Date) -> Bool {
        date <= limit
    }
    
    private var limit: Date {
        switch self {
        case .hour:
            return Calendar.current.date(byAdding: .hour, value: -1, to: .now)!
        case .hours3:
            return Calendar.current.date(byAdding: .hour, value: -3, to: .now)!
        case .hours6:
            return Calendar.current.date(byAdding: .hour, value: -6, to: .now)!
        case .hours12:
            return Calendar.current.date(byAdding: .hour, value: -12, to: .now)!
        case .day:
            return Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        case .days3:
            return Calendar.current.date(byAdding: .day, value: -3, to: .now)!
        case .week:
            return Calendar.current.date(byAdding: .day, value: -7, to: .now)!
        }
    }
}
