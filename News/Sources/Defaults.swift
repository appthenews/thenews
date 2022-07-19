import Foundation

public struct Defaults {
    public static var support: Bool {
        get { UserDefaults.standard.object(forKey: "support") as? Bool ?? false }
        set { UserDefaults.standard.setValue(newValue, forKey: "support") }
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
        ready && !support
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
