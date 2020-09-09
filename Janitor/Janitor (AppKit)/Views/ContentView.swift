//
//  ContentView.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-06.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa
import JanitorKit
import SafePointer



class ContentView: View {
    
    var trackedDirectories: [TrackedDirectory] = [] {
        didSet {
            rebuild()
        }
    }
    
    
    @ObservableMutableSafePointer
    private var currentlyEditedDirectory: TrackedDirectory? = nil
    
    
    init(trackedDirectories: [TrackedDirectory],
         onEdit: @escaping OnEdit) {
        self.trackedDirectories = trackedDirectories
        super.init()
    }
    
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    public var body: NSView {
        AllWatchedFoldersView(trackedDirectories: trackedDirectories, editableDirectory: _currentlyEditedDirectory)
            .sheet(item: _currentlyEditedDirectory, content: sheetContent)
    }
    
    
    
    public typealias OnEdit = (_ newValues: [TrackedDirectory]) -> Void
}



private extension ContentView {
    func sheetContent(for trackedDirectory: MutableSafePointer<TrackedDirectory?>) -> NSView {
        guard let currentEditedDirectory = trackedDirectory.pointee else {
            return WatchedFolderEditView(purpose: .new) { result in
                switch result {
                case .cancelled: return
                case .saved(let newDirectory): self.append(newDirectory: newDirectory)
                }
                
                trackedDirectory.pointee = nil
            }
        }
        
        return WatchedFolderEditView(purpose: .edit(basis: currentEditedDirectory)) { result in
            switch result {
            case .cancelled: return
            case .saved(let newDirectory): trackedDirectory.pointee = newDirectory
            }
            
            trackedDirectory.pointee = nil
        }
    }
    
    
    func append(newDirectory: TrackedDirectory) {
        self.trackedDirectories.append(newDirectory)
    }
}
