import Foundation

extension String {
    var max8: Self {
        Self(decoding: Data(self.utf8).prefix(255), as: UTF8.self)
    }
}
