import AppKit
import Combine

extension Preferences {
    final class Feeds: NSVisualEffectView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init(session: Session) {
            super.init(frame: .init(origin: .zero, size: .init(width: 300, height: 480)))
            
            let theGuardianTitle = Text(vibrancy: true)
            theGuardianTitle.stringValue = "The Guardian"
            
            let theGuardianWorld = Switch(title: "World")
            theGuardianWorld
                .change
                .sink { value in
                    Task {
                        await session.cloud.toggle(source: .theGuardianWorld, value: value)
                    }
                }
                .store(in: &subs)
            
            let theGuardianGermany = Switch(title: "Germany")
            theGuardianGermany
                .change
                .sink { value in
                    Task {
                        await session.cloud.toggle(source: .theGuardianGermany, value: value)
                    }
                }
                .store(in: &subs)
            
            let theGuardianSeparator = Separator()
            
            let reutersTitle = Text(vibrancy: true)
            reutersTitle.stringValue = "Reuters"
            
            let reutersInternational = Switch(title: "International")
            reutersInternational
                .change
                .sink { value in
                    Task {
                        await session.cloud.toggle(source: .reutersInternational, value: value)
                    }
                }
                .store(in: &subs)
            
            let reutersEurope = Switch(title: "Europe")
            reutersEurope
                .change
                .sink { value in
                    Task {
                        await session.cloud.toggle(source: .reutersEurope, value: value)
                    }
                }
                .store(in: &subs)
            
            let reutersSeparator = Separator()
            
            let derSpiegelTitle = Text(vibrancy: true)
            derSpiegelTitle.stringValue = "Der Spiegel"
            
            let derSpiegelInternational = Switch(title: "International")
            derSpiegelInternational
                .change
                .sink { value in
                    Task {
                        await session.cloud.toggle(source: .derSpiegelInternational, value: value)
                    }
                }
                .store(in: &subs)
            
            let derSpiegelSeparator = Separator()
            
            let theLocalTitle = Text(vibrancy: true)
            theLocalTitle.stringValue = "The Local"
            
            let theLocalInternational = Switch(title: "International")
            theLocalInternational
                .change
                .sink { value in
                    Task {
                        await session.cloud.toggle(source: .theLocalInternational, value: value)
                    }
                }
                .store(in: &subs)
            
            let theLocalGermany = Switch(title: "Germany")
            theLocalGermany
                .change
                .sink { value in
                    Task {
                        await session.cloud.toggle(source: .theLocalGermany, value: value)
                    }
                }
                .store(in: &subs)
            
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
            
            let stack = NSStackView(views: [
            theGuardianTitle,
            theGuardianWorld,
            theGuardianGermany,
            theGuardianSeparator,
            reutersTitle,
            reutersInternational,
            reutersEurope,
            reutersSeparator,
            derSpiegelTitle,
            derSpiegelInternational,
            derSpiegelSeparator,
            theLocalTitle,
            theLocalInternational,
            theLocalGermany])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.orientation = .vertical
            stack.alignment = .leading
            addSubview(stack)
            
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
            stack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            
            session
                .cloud
                .first()
                .map(\.preferences.sources)
                .sink { sources in
                    theGuardianWorld.control.state = sources[.theGuardianWorld]! ? .on : .off
                    theGuardianGermany.control.state = sources[.theGuardianGermany]! ? .on : .off
                    reutersInternational.control.state = sources[.reutersInternational]! ? .on : .off
                    reutersEurope.control.state = sources[.reutersEurope]! ? .on : .off
                    derSpiegelInternational.control.state = sources[.derSpiegelInternational]! ? .on : .off
                    theLocalInternational.control.state = sources[.theLocalInternational]! ? .on : .off
                    theLocalGermany.control.state = sources[.theLocalGermany]! ? .on : .off
                }
                .store(in: &subs)
        }
    }
}
