//
//  App.swift
//  Janitor
//
//  Created by Ky Leggiero on 2021-07-17.
//

import SwiftUI

import JanitorKit
import SwiftyUserDefaults



@main
struct App: SwiftUI.App {
    
    @StateObject
    var janitorialEngine: JanitorialEngine
    
    
    init() {
        self._janitorialEngine = .init(
            wrappedValue: sync { await JanitorialEngine(
                dryRun: true,
                coordinatingJanitorsFor: SwiftyUserDefault(keyPath: \.trackedDirectories).wrappedValue
            ) }
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(trackedDirectories: .init(
                get: {             sync { await janitorialEngine.trackedDirectories } },
                set: { newValue in sync { await janitorialEngine.trackedDirectories = newValue } }
            ))
        }
        Settings {
            SettingsView()
        }
    }
}
