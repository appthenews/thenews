import AppKit
import StoreKit

final class Menu: NSMenu, NSMenuDelegate {
    private let session: Session
    
    required init(coder: NSCoder) { fatalError() }
    init(session: Session) {
        self.session = session
        super.init(title: "")
        items = [app, edit, news, window, help]
    }
    
    func menuNeedsUpdate(_ menu: NSMenu) {
        menu.items = newItems
    }
    
    private var app: NSMenuItem {
        .parent("The News", [
            .child("About", #selector(NSApplication.orderFrontStandardAboutPanel(_:))),
            .separator(),
            .child("Preferences...", #selector(App.showPreferencesWindow), ","),
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
            .child("Search", #selector(NSText.selectAll), "a")])
    }
    
    private var news: NSMenuItem {
        .parent("News", newItems) {
            $0.submenu!.delegate = self
            $0.submenu!.autoenablesItems = false
        }
    }
    
    private var window: NSMenuItem {
        .parent("Window", [
            .child("Minimize", #selector(NSWindow.miniaturize), "m"),
            .child("Zoom", #selector(NSWindow.zoom)),
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
    
    private var newItems: [NSMenuItem] {
        [.child("Previous", #selector(triggerUp), "↑") {
            $0.target = self
            $0.isEnabled = session.provider.value != nil
            $0.keyEquivalentModifierMask = []
        },
         .child("Next", #selector(triggerDown), "↓") {
             $0.target = self
             $0.isEnabled = session.provider.value != nil
             $0.keyEquivalentModifierMask = []
         },
         .separator(),
         .child("Continue reading", #selector(triggerOpen), "\r") {
             $0.target = self
             $0.isEnabled = session.item.value != nil
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
    
    @objc private func triggerRate() {
        SKStoreReviewController.requestReview()
    }
}
