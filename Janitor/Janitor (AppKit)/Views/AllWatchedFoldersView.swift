//
//  AllWatchedFoldersView.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-05.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa
import JanitorKit
import RectangleTools
import SafePointer



private let viewPadding: CGFloat = 12



public class AllWatchedFoldersView: View {
    
    var trackedDirectories: [TrackedDirectory] = [] {
        didSet { rebuild() }
    }
    
    @ObservableSafeMutablePointer
    var currentlyEditedDirectory: TrackedDirectory?
    
    
    init(trackedDirectories: [TrackedDirectory], editableDirectory: ObservableSafeMutablePointer<TrackedDirectory?>) {
        self.trackedDirectories = trackedDirectories
        self._currentlyEditedDirectory = editableDirectory
        super.init()
    }
    
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    public var body: some NSView {
        NSScrollView {
            VStack(watchedFolderViews)
                .fullWidthViews(padding: NativeEdgeInsets(each: viewPadding))
        }
        .verticallyScrollingContent(padding: NativeEdgeInsets(each: viewPadding))
        .background(.clear)
    }
}

private extension AllWatchedFoldersView {
    var watchedFolderViews: [WatchedFolderView] {
        trackedDirectories.map { WatchedFolderView(trackedDirectory: $0, onEditPressed: beginEditing) }
    }
    
    
    func beginEditing(folder: ObservableSafeMutablePointer<TrackedDirectory>) {
        var observerId = ObserverIdentifier()
        observerId = self._currentlyEditedDirectory.addObserver { [weak self] (old, new) in
            if let new = new {
                folder.pointee = new
            }
            else {
                self?._currentlyEditedDirectory.removeObserver(withId: observerId)
                self?.currentlyEditedDirectory = nil
            }
        }
        
        self.currentlyEditedDirectory = folder.pointee
    }
}
