import Foundation

public struct Defaults {
    public static var sponsor: Bool {
        get { UserDefaults.standard.object(forKey: "sponsor") as? Bool ?? false }
        set { UserDefaults.standard.setValue(newValue, forKey: "sponsor") }
    }
    
    public static var ready: Bool {
        created
            .map {
                let days = Calendar.current.dateComponents([.day], from: $0, to: .init()).day!
                return days > 1
            }
        ?? false
    }
    
    public static var froob: Bool {
        ready && !sponsor
    }
    
    private static var created: Date? {
        get { UserDefaults.standard.object(forKey: "created") as? Date }
        set { UserDefaults.standard.setValue(newValue, forKey: "created") }
    }
    
    public static func start() {
        if created == nil {
            created = .init()
        }
    }
    
    private init() { }
}
