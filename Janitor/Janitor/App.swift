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
    
    @State
    var janitorialEngine: JanitorialEngine!
    
    @State
    var trackedDirectoriesMirror: [TrackedDirectory] = []
    
    @State
    var janitorialEngineActivityFeed: JanitorialEngine.ActivityFeed = .dummyThatNeverPublishes()
    
    @State
    var isReady = false
    
    
    var body: some Scene {
        WindowGroup {
            ContentView(isReady: isReady, trackedDirectories: .init(
                get: { self.trackedDirectoriesMirror },
                set: { newValue in
                    Task {
                        await janitorialEngine.setTrackedDirectories(newValue)
                    }
                }
            ))
//            Button("Update") {
//                Task {
//                    await janitorialEngine.setTrackedDirectories([.init(uuid: UUID(), isEnabled: false, url: URL(fileURLWithPath: "/dev/null"), oldestAllowedAge: 7.days, largestAllowedTotalSize: 12.megabytes)])
//                }
//            }
            
            
            // MARK: Hook up the Janitorial engine
            
            .environment(janitorialEngine)
            
            .task {
                janitorialEngine = await JanitorialEngine(
                    dryRun: true,
                    preparingJanitorsFor: SwiftyUserDefault(keyPath: \.trackedDirectories).wrappedValue
                )
                
                self.janitorialEngineActivityFeed = await janitorialEngine!.activityFeed
                
                await janitorialEngine.start()
            }
            
            .onReceive(janitorialEngineActivityFeed) { activity in
                switch activity {
                case .ready(initialJanitors: let initialJanitors):
                    self.trackedDirectoriesMirror = initialJanitors.map { $0.trackedDirectory }
                    self.isReady = true
                    
                case .janitorsChanged(newJanitors: let newJanitors):
                    self.trackedDirectoriesMirror = newJanitors.map { $0.trackedDirectory }
                    
                case .error(_),
                        .janitorDidStart(id: _),
                        .janitorDidStop(id: _),
                        .didRemoveItem,
                        .dryRunDidChange(newValue: _):
                    return
                }
            }
        }
        Settings {
            SettingsView()
        }
    }
}
