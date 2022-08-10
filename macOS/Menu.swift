import AppKit
import StoreKit

final class Menu: NSMenu, NSMenuDelegate {
    private let session: Session
    private let shortcut = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    required init(coder: NSCoder) { fatalError() }
    init(session: Session) {
        self.session = session
        super.init(title: "")
        items = [app, edit, news, window, help]
        
        shortcut.button!.image = .init(named: "status")
        shortcut.button!.target = self
        shortcut.button!.action = #selector(triggerShortcut)
        shortcut.button!.sendAction(on: [.leftMouseUp, .rightMouseUp])
        shortcut.button!.menu = .init()
        shortcut.button!.menu!.items = [
            .child("The News", #selector(triggerShow)) {
                $0.target = self
            }]
    }
    
    func menuNeedsUpdate(_ menu: NSMenu) {
        menu.items = newsItems
    }
    
    private var app: NSMenuItem {
        .parent("The News", [
            .child("About", #selector(NSApplication.orderFrontStandardAboutPanel(_:))),
            .separator(),
            .child("Preferences...", #selector(App.showPreferencesWindow), ","),
            .separator(),
            .child("Sponsor", #selector(App.showSponsor), ","),
            .separator(),
            .child("Hide", #selector(NSApplication.hide), "h"),
            .child("Hide Others", #selector(NSApplication.hideOtherApplications), "h") {
                $0.keyEquivalentModifierMask = [.option, .command]
            },
            .child("Show all", #selector(NSApplication.unhideAllApplications)),
            .separator(),
            .child("Quit", #selector(NSApplication.terminate), "q")])
    }
    
    private var edit: NSMenuItem {
        .parent("Edit", [
            .child("Undo", Selector(("undo:")), "z"),
            .child("Redo", Selector(("redo:")), "Z"),
            .separator(),
            .child("Cut", #selector(NSText.cut), "x"),
            .child("Copy", #selector(NSText.copy(_:)), "c"),
            .child("Paste", #selector(NSText.paste), "v"),
            .child("Delete", #selector(NSText.delete)),
            .child("Select All", #selector(NSText.selectAll), "a"),
            .separator(),
            .child("Search", #selector(triggerFind), "f") {
                $0.target = self
            }])
    }
    
    private var news: NSMenuItem {
        .parent("News", newsItems) {
            $0.submenu!.delegate = self
            $0.submenu!.autoenablesItems = false
        }
    }
    
    private var window: NSMenuItem {
        .parent("Window", [
            .child("Minimize", #selector(NSWindow.miniaturize), "m"),
            .child("Zoom", #selector(NSWindow.zoom)),
            .separator(),
            .child("Close", #selector(NSWindow.close), "w"),
            .separator(),
            .child("Bring All to Front", #selector(NSApplication.arrangeInFront)),
            .separator()])
    }
    
    private var help: NSMenuItem {
        .parent("Help", [
            .child("Rate on the App Store", #selector(triggerRate)) {
                $0.target = self
            }])
    }
    
    private var newsItems: [NSMenuItem] {
        [.child("Previous", #selector(triggerUp), "↑") {
            $0.target = self
            $0.isEnabled = session.provider.value != nil && !session.loading.value
            $0.keyEquivalentModifierMask = []
        },
         .child("Next", #selector(triggerDown), "↓") {
             $0.target = self
             $0.isEnabled = session.provider.value != nil && !session.loading.value
             $0.keyEquivalentModifierMask = []
         },
         .separator(),
         .child("Go to article", #selector(triggerOpen), "\r") {
             $0.target = self
             $0.isEnabled = session.item.value != nil && !session.loading.value
             $0.keyEquivalentModifierMask = []
         },
         .separator(),
         .child("Delete article", #selector(triggerTrash), .init(Unicode.Scalar(NSBackspaceCharacter)!)) {
             $0.target = self
             $0.isEnabled = session.item.value != nil && !session.loading.value
             $0.keyEquivalentModifierMask = []
         }]
    }
    
    @objc private func triggerUp() {
        session.up.send()
    }
    
    @objc private func triggerDown() {
        session.down.send()
    }
    
    @objc private func triggerOpen() {
        session.open.send()
    }
    
    @objc private func triggerTrash() {
        session.trash.send()
    }
    
    @objc private func triggerFind() {
        guard !session.loading.value, session.columns.value != 2 else { return }
        if session.provider.value == nil {
            session.provider.value = .all
        }
        session.find.send()
    }
    
    @objc private func triggerRate() {
        SKStoreReviewController.requestReview()
    }
    
    @objc private func triggerShortcut(_ button: NSStatusBarButton) {
        guard let event = NSApp.currentEvent, !session.loading.value else { return }
        
        switch event.type {
        case .rightMouseUp:
            NSMenu.popUpContextMenu(button.menu!, with: event, for: button)
        case .leftMouseUp:
            NSPopover().show(content: Shortcut(session: session), on: button, edge: .minY)
        default:
            break
        }
    }
    
    @objc private func triggerShow(_ button: NSStatusBarButton) {
        NSApp.activate(ignoringOtherApps: true)
        let window = NSApp
            .windows
            .first { $0 is Window }
        window?.orderFrontRegardless()
    }
}
