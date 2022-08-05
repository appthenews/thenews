import AppKit
import Coffee
import News

extension Preferences.Feeds {
    final class Switch: NSView {
        private let session: Session
        private let feed: Feed
        
        required init?(coder: NSCoder) { nil }
        init(session: Session, feed: Feed) {
            self.session = session
            self.feed = feed
            
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            let text = Text(vibrancy: false)
            text.stringValue = feed.title
            text.font = .preferredFont(forTextStyle: .callout)
            text.textColor = .secondaryLabelColor
            addSubview(text)
            
            let control = NSSwitch()
            control.target = self
            control.action = #selector(changing)
            control.translatesAutoresizingMaskIntoConstraints = false
            control.controlSize = .small
            addSubview(control)
            
            rightAnchor.constraint(equalTo: text.rightAnchor, constant: 2).isActive = true
            bottomAnchor.constraint(equalTo: control.bottomAnchor, constant: 2).isActive = true
            
            text.leftAnchor.constraint(equalTo: control.rightAnchor, constant: 10).isActive = true
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            control.leftAnchor.constraint(equalTo: leftAnchor, constant: 2).isActive = true
            control.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
            
            Task {
                control.state = await session.cloud.model.preferences.feeds[feed]! ? .on : .off
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
        
        @objc private func changing(control: NSSwitch) {
            Task {
                await session.cloud.toggle(feed: feed, value: control.state == .on)
            }
        }
    }
}
