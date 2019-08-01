//
//  AllWatchedFoldersSettingsView.swift
//  Janitor
//
//  Created by Ben Leggiero on 7/18/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import JanitorKit



struct AllWatchedFoldersSettingsView: View {
    
    @Inout
    var trackedDirectories: [TrackedDirectory]
    
    @Inout
    var currentlyEditedDirectory: TrackedDirectory?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                ForEach(_trackedDirectories) { (trackedDirectory: Inout<TrackedDirectory>) -> WatchedFolderSettingsView in
                    WatchedFolderSettingsView(trackedDirectory: trackedDirectory,
                                              onDidPressEditButton: { self.beginEditing(trackedDirectory) },
                                              onDidPressDeleteButton: { self.delete(trackedDirectory.value) })
                }
            }
        }
        .frame(minHeight: 100)
    }
    
    
    func beginEditing(_ directoryToBeEdited: Inout<TrackedDirectory>) {
        self.currentlyEditedDirectory = directoryToBeEdited.value
    }
    
    
    func delete(_ trackedDirectory: TrackedDirectory) {
        trackedDirectories.remove(firstElementWithId: trackedDirectory.id)
    }
}

#if DEBUG
struct AllWatchedFoldersSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AllWatchedFoldersSettingsView(trackedDirectories: .constant([
            TrackedDirectory(url: URL.User.downloads!,
                             oldestAllowedAge: 30.days,
                             largestAllowedTotalSize: 1.gibibytes)
            ]),
                                      currentlyEditedDirectory: .constant(nil)
        )
    }
}
#endif
