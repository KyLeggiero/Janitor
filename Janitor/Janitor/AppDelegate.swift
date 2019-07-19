//
//  AppDelegate.swift
//  Janitor
//
//  Created by Ben Leggiero on 7/17/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Cocoa
import SwiftUI
import JanitorKit



@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    lazy var window: NSWindow = generateWindow()
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setUpMenuBarItem()
        runInForeground()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}



extension AppDelegate {
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        runInBackground()
        return .terminateCancel
    }
    
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}



extension AppDelegate {
    @IBAction
    func didSelectQuitEntirelyMenuItem(sender: NSMenuItem) {
        NSApp.terminate(sender)
    }
    
    
    @IBAction
    func didSelectRunJanitorInBackground(sender: NSMenuItem) {
        runInBackground()
    }
}



extension AppDelegate {
    func runInBackground(closeWindow: Bool = true) {
        if closeWindow {
            window.close()
        }
        DispatchQueue.main.async {
            NSApp.setActivationPolicy(.accessory)
        }
    }
    
    
    func runInForeground() {
        NSApp.setActivationPolicy(.regular)
        generateAndShowWindow()
    }
    
    
    private func generateAndShowWindow() {
        window.makeKeyAndOrderFront(self)
    }
    
    
    private func generateWindow() -> NSWindow {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.tabbingMode = .disallowed
        window.isReleasedWhenClosed = false
        window.delegate = self

        window.contentView = NSHostingView(rootView: ContentView(watchedLocations: [URL.User.desktop!]))
//        window.contentView?.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return window
    }
}



extension AppDelegate: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        runInBackground(closeWindow: false)
    }
}



extension AppDelegate {
    
    func setUpMenuBarItem() {
        guard let button = statusItem.button else {
            assertionFailure("no menu bar icon....?")
            return
        }
        button.image = .menuBarIcon
        button.target = self
        button.action = #selector(didPressMenuBarButton)
    }
    
    
    @objc
    func didPressMenuBarButton(sender: Any) {
        runInForeground()
    }
}
