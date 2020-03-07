//
//  ContentView.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-06.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa
import JanitorKit



class ContentView: View {
    
    var trackedDirectories: [TrackedDirectory] = [] {
        didSet {
            rebuild()
        }
    }
    
    
    init(trackedDirectories: [TrackedDirectory]) {
        self.trackedDirectories = trackedDirectories
        super.init()
    }
    
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    public var body: some NSView {
        AllWatchedFoldersView(trackedDirectories: trackedDirectories)
    }
}
