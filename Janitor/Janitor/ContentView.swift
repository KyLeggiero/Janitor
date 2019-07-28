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
    
    @Binding
    var trackedDirectories: [TrackedDirectory]
    
    @State
    private var currentlyEditedDirectory: TrackedDirectory? = nil

    @Binding
    private var isEditTrackedDirectorySheetShown: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            AllWatchedFoldersSettingsView(trackedDirectories: $trackedDirectories)
            Button(action: {
                    self.isEditTrackedDirectorySheetShown = true
                },
                label: {
                    HStack {
                        Text("􀅼")
                        Text("Track another")
                    }
                }
            )
        }
        .padding()
        .sheet(isPresented: $isEditTrackedDirectorySheetShown, content: {
            NewWatchedFolderSetupView(onComplete: { newTrackedDirectory in
                self.currentlyEditedDirectory = nil
                if let newTrackedDirectory = newTrackedDirectory {
                    self.trackedDirectories.replaceOrAppend(newTrackedDirectory)
                }
            })
            .padding()
        })
    }
    
    
    init(trackedDirectories: Binding<[TrackedDirectory]>) {
        
        self._trackedDirectories = trackedDirectories
        
        self._isEditTrackedDirectorySheetShown = Binding<Bool>(
           getValue: {
               nil != self.currentlyEditedDirectory
           },
           setValue: { newIsShown in
               if !newIsShown {
                   self.currentlyEditedDirectory = nil
               }
           }
       )
    }
    
    
    func didCompleteNewTrackedDirSelection(newTrackedDirectory: TrackedDirectory?) {
        if let newTrackedDirectory = newTrackedDirectory {
            trackedDirectories.append(newTrackedDirectory)
        }
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
