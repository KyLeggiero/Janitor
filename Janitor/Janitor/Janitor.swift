//
//  Janitor.swift
//  Janitor
//
//  Created by Ben Leggiero on 2020-09-09.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import SwiftUI
import JanitorKit



@main
public struct Janitor: App {
    
    @ArbitraryAppStorage
    var trackedDirectories: [TrackedDirectory] = []
    
    
    @SceneBuilder
    public var body: some Scene {
        WindowGroup {
            ContentView(trackedDirectories: trackedDirectories)
        }
    }
}
