import Foundation

public enum Interval: UInt8, CaseIterable {
    case
    hours3,
    hours6,
    day,
    week
    
    func passed(date: Date) -> Bool {
        date <= limit
    }
    
    private var limit: Date {
        switch self {
        case .hours3:
            return Calendar.current.date(byAdding: .hour, value: -3, to: .now)!
        case .hours6:
            return Calendar.current.date(byAdding: .hour, value: -6, to: .now)!
        case .day:
            return Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        case .week:
            return Calendar.current.date(byAdding: .day, value: -7, to: .now)!
        }
    }
}
