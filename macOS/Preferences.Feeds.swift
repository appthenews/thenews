import AppKit

extension Preferences {
    final class Feeds: NSVisualEffectView {
        required init?(coder: NSCoder) { nil }
        init(session: Session) {
            super.init(frame: .init(origin: .zero, size: .init(width: 300, height: 480)))
            
            let theGuardianTitle = Text(vibrancy: true)
            theGuardianTitle.stringValue = "The Guardian"
            let theGuardianSeparator = Separator()
            
            let reutersTitle = Text(vibrancy: true)
            reutersTitle.stringValue = "Reuters"
            let reutersSeparator = Separator()
            
            let derSpiegelTitle = Text(vibrancy: true)
            derSpiegelTitle.stringValue = "Der Spiegel"
            let derSpiegelSeparator = Separator()
            
            let theLocalTitle = Text(vibrancy: true)
            theLocalTitle.stringValue = "The Local"
            
            [theGuardianTitle,
             reutersTitle,
             derSpiegelTitle,
             theLocalTitle]
                .forEach {
                    $0.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .medium)
                    $0.textColor = .secondaryLabelColor
                }
            
            [theGuardianSeparator,
             reutersSeparator,
             derSpiegelSeparator]
                .forEach {
                    $0.heightAnchor.constraint(equalToConstant: 1).isActive = true
                    $0.widthAnchor.constraint(equalToConstant: 180).isActive = true
                }
            
            let stack = Stack(views: [
                theGuardianTitle,
                Switch(session: session, feed: .theGuardianWorld),
                Switch(session: session, feed: .theGuardianGermany),
                theGuardianSeparator,
                reutersTitle,
                Switch(session: session, feed: .reutersInternational),
                Switch(session: session, feed: .reutersEurope),
                reutersSeparator,
                derSpiegelTitle,
                Switch(session: session, feed: .derSpiegelInternational),
                derSpiegelSeparator,
                theLocalTitle,
                Switch(session: session, feed: .theLocalInternational),
                Switch(session: session, feed: .theLocalGermany)])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.orientation = .vertical
            stack.alignment = .leading
            addSubview(stack)
            
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
            stack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
    }
}
