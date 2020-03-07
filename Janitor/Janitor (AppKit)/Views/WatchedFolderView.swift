//
//  WatchedFolderView.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-06.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa
import JanitorKit



class WatchedFolderView: View {
    
    var trackedDirectory: TrackedDirectory
    
    
    init(trackedDirectory: TrackedDirectory) {
        self.trackedDirectory = trackedDirectory
        super.init()
    }
    
    
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) is not supported by this View")
    }
    
    
    

    var body: some NSView {
        NSBox(frame: NSRect(origin: frame.origin, size: intrinsicContentSize))
            .title(trackedDirectory.url.lastPathComponent)
    }
    
    
    override var intrinsicContentSize: NSSize { NSSize(width: 50, height: 50) }
}
