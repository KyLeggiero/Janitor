//
//  WatchedFolderEditView.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-27.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa
import TODO
import JanitorKit
import SafePointer
import Atomic



class WatchedFolderEditView: View {
    
    private let purpose: Purpose
    private let onUserDoneEditing: OnUserDoneEditing
    
    @ObservableMutableSafePointer
    private var trackedDirectory: TrackedDirectory
    
    @ObservableSafeMutablePointer
    private var trackedDirectoryUrl: URL?
    
    private var trackedDirectoryUrlObserverIdentifier = ObserverIdentifier()
    
    @Atomic
    private var safeToUpdateTrackedDirectory = true
    
    
    init(purpose: Purpose, onUserDoneEditing: @escaping OnUserDoneEditing) {
        self.purpose = purpose
        self.onUserDoneEditing = onUserDoneEditing
        
        let trackedDirectory: TrackedDirectory
        
        switch purpose {
        case .new:
            trackedDirectory = .default()
            
        case .edit(let directory):
            trackedDirectory = directory
        }
        
        self.trackedDirectory = trackedDirectory
        
        super.init()
        
        self._trackedDirectoryUrl = .init(to: trackedDirectory.url,
                                          newObserverIdentifier: &trackedDirectoryUrlObserverIdentifier)
        { [weak self] _, new in
            if let self = self,
                self.safeToUpdateTrackedDirectory,
                let new = new
            {
                self.trackedDirectory.url = new
            }
        }
    }
    
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var body: some NSView {
        VStack {
            NSTextField(labelWithString: "Add a folder to the cleaning schedule")
            SelectFileControl(selectedFile: _trackedDirectoryUrl)
            MeasurementPicker(preamble: "No file older than", measurement: _trackedDirectory_oldestAllowedAge.binding, presentedUnits: Age.Unit.commonFileAgeCases, postamble: nil)
//            MeasurementPicker(preamble: "Overall no more than", measurement: _trackedDirectory_largestAllowedTotalSize.binding, presentedUnits: DataSize.Unit.commonSIFileSizeCases, postamble: nil)
            HStack {
                Spacer()
                Button("Cancel", action: didPressCancel)
                Button("Save", action: didPressSave)
                    .defaultButton()
            }
        }
    }
}



extension WatchedFolderEditView {
    typealias OnUserDoneEditing = (EditResult) -> Void
    
    
    
    enum EditResult {
        case cancelled
        case saved(newDirectory: TrackedDirectory)
    }
    
    
    
    enum Purpose {
        case new
        case edit(basis: TrackedDirectory)
    }
}



private extension WatchedFolderEditView {
    
    func didPressCancel(sender: Button) {
        self.onUserDoneEditing(.cancelled)
    }
    
    
    func didPressSave(sender: Button) {
        self.onUserDoneEditing(.saved(newDirectory: trackedDirectory))
    }
}
