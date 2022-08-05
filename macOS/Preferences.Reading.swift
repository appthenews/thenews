import AppKit
import Coffee
import News

extension Preferences {
    final class Reading: NSVisualEffectView {
        private let session: Session
        
        required init?(coder: NSCoder) { nil }
        init(session: Session) {
            self.session = session
            super.init(frame: .init(origin: .zero, size: .init(width: 400, height: 330)))
            let titleReader = Text(vibrancy: false)
            titleReader.stringValue = "Reader"
            titleReader.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .medium)
            titleReader.textColor = .controlAccentColor
            
            let reader = NSView()
            reader.translatesAutoresizingMaskIntoConstraints = false
            
            let control = NSSwitch()
            control.target = self
            control.action = #selector(changing)
            control.translatesAutoresizingMaskIntoConstraints = false
            control.state = session.reader.value ? .on : .off
            reader.addSubview(control)
            
            let subtitleReader = Text(vibrancy: true)
            subtitleReader.stringValue = "Make reading easy on the eyes"
            subtitleReader.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .regular)
            subtitleReader.textColor = .secondaryLabelColor
            subtitleReader.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            reader.addSubview(subtitleReader)
            
            let titleFont = Text(vibrancy: false)
            titleFont.stringValue = "Font size"
            titleFont.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .medium)
            titleFont.textColor = .controlAccentColor
            
            let small = Text(vibrancy: true)
            small.font = NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize - 2, weight: .regular)
            small.stringValue = "A"
            small.textColor = .tertiaryLabelColor
            addSubview(small)
            
            let large = Text(vibrancy: true)
            large.font = NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize + 14, weight: .regular)
            large.stringValue = "A"
            large.textColor = .tertiaryLabelColor
            addSubview(large)
            
            let slider = NSSlider(value: session.font.value,
                                  minValue: -2,
                                  maxValue: 14,
                                  target: self,
                                  action: #selector(update))
            slider.allowsTickMarkValuesOnly = true
            slider.numberOfTickMarks = 9
            slider.translatesAutoresizingMaskIntoConstraints = false
            addSubview(slider)
            
            let stack = Stack(views: [
                titleReader,
                reader,
                titleFont,
                slider])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.orientation = .vertical
            stack.alignment = .left
            stack.spacing = 10
            stack.setCustomSpacing(50, after: reader)
            addSubview(stack)
            
            reader.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            control.leftAnchor.constraint(equalTo: reader.leftAnchor).isActive = true
            control.centerYAnchor.constraint(equalTo: reader.centerYAnchor).isActive = true
            
            subtitleReader.leftAnchor.constraint(equalTo: control.rightAnchor, constant: 10).isActive = true
            subtitleReader.centerYAnchor.constraint(equalTo: reader.centerYAnchor).isActive = true
            subtitleReader.rightAnchor.constraint(lessThanOrEqualTo: reader.rightAnchor).isActive = true
            
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
            stack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            stack.widthAnchor.constraint(equalToConstant: 200).isActive = true
            
            slider.widthAnchor.constraint(equalToConstant: 200).isActive = true
            
            small.centerYAnchor.constraint(equalTo: slider.centerYAnchor).isActive = true
            small.rightAnchor.constraint(equalTo: slider.leftAnchor, constant: -12).isActive = true
            
            large.centerYAnchor.constraint(equalTo: slider.centerYAnchor).isActive = true
            large.leftAnchor.constraint(equalTo: slider.rightAnchor, constant: 12).isActive = true
        }
        
        @objc private func update(_ slider: NSSlider) {
            guard session.font.value != slider.doubleValue else { return }
            session.font.value = slider.doubleValue
            UserDefaults.standard.set(slider.doubleValue, forKey: "font")
        }
        
        @objc private func changing(control: NSSwitch) {
            session.reader.value = control.state == .on
            UserDefaults.standard.set(control.state == .on, forKey: "reader")
        }
    }
}
