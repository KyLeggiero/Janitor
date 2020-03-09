//
//  AllWatchedFoldersView.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-05.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa
import JanitorKit



private let padding: CGFloat = 12



public class AllWatchedFoldersView: View {
    
    var trackedDirectories: [TrackedDirectory] = [] {
        didSet { rebuild() }
    }
    
    
    init(trackedDirectories: [TrackedDirectory]) {
        self.trackedDirectories = trackedDirectories
        super.init()
    }
    
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    public var body: some NSView {
        NSScrollView {
            VStack(watchedFolderViews)
                .fullWidthViews(padding: NSEdgeInsets(each: padding))
        }
        .verticallyScrollingContent(padding: NSEdgeInsets(each: padding))
        .background(.clear)
    }
    
    
    private var watchedFolderViews: [WatchedFolderView] {
        trackedDirectories.map { WatchedFolderView(trackedDirectory: $0) }
    }
}
