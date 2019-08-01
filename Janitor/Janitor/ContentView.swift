//
//  ContentView.swift
//  Janitor
//
//  Created by Ben Leggiero on 7/17/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import JanitorKit



struct ContentView: View {
    
    @Inout
    var trackedDirectories: [TrackedDirectory]

    @BoundPointer
    private var currentlyEditedDirectory: TrackedDirectory? = nil

    @BoundPointer
    private var isEditTrackedDirectorySheetShown = false


    init(trackedDirectories: Inout<[TrackedDirectory]>) {

        self._trackedDirectories = trackedDirectories

        self._currentlyEditedDirectory.didSet =
            self.currentlyEditedDirectoryPointerDidChange(newPointee:)
        
        self._isEditTrackedDirectorySheetShown.didSet = {
            print($0)
        }
    }
    
    
    var body: some View {
//        Text("Whoops")
        VStack(alignment: HorizontalAlignment.center) {
            AllWatchedFoldersSettingsView(trackedDirectories: $trackedDirectories,
                                          currentlyEditedDirectory: _currentlyEditedDirectory.binding)
            Button(
                action: {
                    self.currentlyEditedDirectory = TrackedDirectory.default
                },
                label: {
                    HStack {
                        Text("􀅼")
                        Text("Track another")
                    }
                }
            )
        }
            .sheet(item: _currentlyEditedDirectory.binding, content: sheetContent)
            .padding()
    }
    
    
    private func didCompleteNewTrackedDirSelection(newTrackedDirectory: TrackedDirectory?) {
        if let newTrackedDirectory = newTrackedDirectory {
            trackedDirectories.append(newTrackedDirectory)
        }
    }


    private func currentlyEditedDirectoryPointerDidChange(newPointee: TrackedDirectory?) {
        self.isEditTrackedDirectorySheetShown = nil != newPointee
    }
    
    
    func sheetContent(currentlyEditedDirectory: TrackedDirectory) -> some View {
        var currentlyEditedDirectory: TrackedDirectory = currentlyEditedDirectory
        let trackedDirectoryBinding = Binding(
            getValue: { currentlyEditedDirectory },
            setValue: { currentlyEditedDirectory = $0 }
        )
        return NewWatchedFolderSetupView(
            trackedDirectory: trackedDirectoryBinding,
            onComplete: { newTrackedDirectory in
                self.currentlyEditedDirectory = nil
                if let newTrackedDirectory = newTrackedDirectory {
                    self.trackedDirectories.replaceOrAppend(newTrackedDirectory)
                }
        })
            .padding()
    }
}


#if DEBUG
let exampleDirectories = [
    TrackedDirectory(url: URL.User.desktop!, oldestAllowedAge: 6.0.days, largestAllowedTotalSize: 2.0.gigabytes),
]

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView(trackedDirectories: .constant(exampleDirectories))
    }
}
#endif
