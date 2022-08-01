import SwiftUI

struct Progress: Shape {
    var value: Double

    func path(in rect: CGRect) -> Path {
        .init {
            $0.move(to: .init(x: 0, y: rect.height / 2))
            $0.addLine(to: .init(x: value * rect.width, y: rect.height / 2))
        }
    }

    var animatableData: Double {
        get {
            value
        }
        set {
            value = newValue
        }
    }
}
