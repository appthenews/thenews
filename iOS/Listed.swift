import SwiftUI

struct Listed: ButtonStyle {
    let pressed: (Bool) -> Void
    
    func makeBody(configuration: Configuration) -> some View {
        pressed(configuration.isPressed)
        return configuration.label.background(Color.clear)
    }
}
