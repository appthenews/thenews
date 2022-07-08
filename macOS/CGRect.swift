import Foundation

extension CGRect {
    var bounded: Self {
        .init(x: max(0, minX), y: max(0, minY), width: width, height: height)
    }
}
