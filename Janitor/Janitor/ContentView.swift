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

    @State
    private var currentlyEditedDirectory: TrackedDirectory? = nil


    init(trackedDirectories: Inout<[TrackedDirectory]>) {
        self._trackedDirectories = trackedDirectories
    }
    
    
    var body: some View {
        VStack(alignment: HorizontalAlignment.center) {
            AllWatchedFoldersView(trackedDirectories: $trackedDirectories,
                                          currentlyEditedDirectory: $currentlyEditedDirectory)
            Button(
                action: {
                    self.currentlyEditedDirectory = TrackedDirectory.default()
                },
                label: {
                    HStack {
                        Text("􀅼")
                        Text("Track another")
                    }
                }
            )
        }
            .sheet(item: $currentlyEditedDirectory, content: sheetContent)
            .padding()
            .frame(minWidth: 512, idealWidth: 640, minHeight: 200, idealHeight: 480, alignment: Alignment.top)
    }
    
    
    private func didCompleteNewTrackedDirSelection(newTrackedDirectory: TrackedDirectory?) {
        if let newTrackedDirectory = newTrackedDirectory {
            trackedDirectories.append(newTrackedDirectory)
        }
    }
    
    
    func sheetContent(currentlyEditedDirectory: TrackedDirectory) -> some View {
        var currentlyEditedDirectory: TrackedDirectory = currentlyEditedDirectory
        let trackedDirectoryBinding = Binding(
            get: { currentlyEditedDirectory },
            set: { currentlyEditedDirectory = $0 }
        )
        return WatchedFolderEditView(
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
struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView(trackedDirectories: .constant([.default()]))
    }
}
#endif
