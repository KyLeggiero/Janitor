//
//  AppDelegate.swift
//  Janitor
//
//  Created by Ben Leggiero on 7/17/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Cocoa
#if PrefersSwiftUI
import SwiftUI
#endif
import JanitorKit
import Atomic



@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    #if PrefersSwiftUI
    lazy var window: NSWindow = generateWindow()
    #else
    @IBOutlet
    var window: NSWindow!
    #endif
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    @Atomic(wrappedValue: [], queue: DispatchQueue(label: "Janitorial Engine Mutation Lock", qos: .utility))
    var engines: [JanitorialEngine]
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setUpMenuBarItem()
        runInForeground()
        startMonitoring()
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
        configure(window: window)
        window.makeKeyAndOrderFront(self)
    }
    
    
    #if PrefersSwiftUI
    private func generateWindow() -> NSWindow {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered, defer: false)
        
        window.contentView = NSHostingView(rootView: ContentView(trackedDirectories: UserPreferences.Bindings.trackedDirectories))
        
        return window
    }
    #endif
    
    
    private func configure(window: NSWindow) {
        window.center()
        window.title = "Janitor"
        window.tabbingMode = .disallowed
        window.isReleasedWhenClosed = false
        window.delegate = self
        window.titlebarAppearsTransparent = true
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



private extension AppDelegate {
    
    func startMonitoring() {
        _engines.performUnsafeOperation { engines in
            UserPreferences.trackedDirectories.forEach { directory in
                engines.append(JanitorialEngine(trackedDirectory: directory,
                                                checkingInterval: TimeInterval(UserPreferences.checkingDelay)))
            }
        }
        
        
        UserPreferences.onTrackedDirectoriesDidChange { _ in
            self.stopMonitoring()
            self.startMonitoring()
            return .thisIsTheTailEndOfTheCallbackChain
        }
    }
    
    
    func stopMonitoring() {
        self.engines = []
    }
}
