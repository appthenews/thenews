import AppKit
import News

extension Preferences {
    final class Feeds: NSVisualEffectView {
        required init?(coder: NSCoder) { nil }
        init(session: Session) {
            super.init(frame: .init(origin: .zero, size: .init(width: 400, height: 360)))
            let stack = Stack(views: [make(provider: .theGuardian, session: session),
                                      make(provider: .reuters, session: session),
                                      make(provider: .derSpiegel, session: session),
                                      make(provider: .theLocal, session: session)])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.orientation = .vertical
            stack.alignment = .leading
            stack.spacing = 20
            addSubview(stack)
            
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
            stack.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -30).isActive = true
        }
        
        private func make(provider: Provider, session: Session) -> Stack {
            let label = Text(vibrancy: false)
            label.stringValue = provider.title
            label.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .medium)
            label.textColor = .controlAccentColor
            label.alignment = .right
            label.widthAnchor.constraint(equalToConstant: 140).isActive = true
            
            let switches = Stack(views: Feed
                .allCases
                .filter {
                    $0.provider == provider
                }
                .map {
                    Switch(session: session, feed: $0)
                })
            switches.orientation = .vertical
            switches.alignment = .leading
            switches.spacing = 1
            return .init(views: [label, switches])
        }
    }
}
