import AppKit
import News

extension Preferences {
    final class Font: NSVisualEffectView {
        private let session: Session
        
        required init?(coder: NSCoder) { nil }
        init(session: Session) {
            self.session = session
            super.init(frame: .init(origin: .zero, size: .init(width: 400, height: 240)))
            let title = Text(vibrancy: false)
            title.stringValue = "Font size"
            title.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .medium)
            title.textColor = .controlAccentColor
            
            let small = Text(vibrancy: true)
            small.font = NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .regular)
            small.stringValue = "A"
            small.textColor = .secondaryLabelColor
            addSubview(small)
            
            let large = Text(vibrancy: true)
            large.font = NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize + 10, weight: .regular)
            large.stringValue = "A"
            large.textColor = .secondaryLabelColor
            addSubview(large)
            
            let slider = NSSlider(value: .init(session.font.value),
                                  minValue: 0,
                                  maxValue: 10,
                                  target: self,
                                  action: #selector(update))
            slider.allowsTickMarkValuesOnly = true
            slider.numberOfTickMarks = 6
            slider.translatesAutoresizingMaskIntoConstraints = false
            slider.widthAnchor.constraint(equalToConstant: 200).isActive = true
            addSubview(slider)
            
            let stack = Stack(views: [
                title,
                slider])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.orientation = .vertical
            stack.spacing = 50
            addSubview(stack)
            
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
            stack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            
            small.centerYAnchor.constraint(equalTo: stack.centerYAnchor, constant: 10).isActive = true
            small.leftAnchor.constraint(equalTo: stack.leftAnchor).isActive = true
            
            large.bottomAnchor.constraint(equalTo: small.bottomAnchor).isActive = true
            large.rightAnchor.constraint(equalTo: stack.rightAnchor).isActive = true
        }
        
        @objc private func update(_ slider: NSSlider) {
            guard session.font.value != slider.integerValue else { return }
            session.font.value = slider.integerValue
            UserDefaults.standard.set(slider.integerValue, forKey: "font")
            print(slider.integerValue)
        }
    }
}
