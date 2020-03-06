//
//  AllWatchedFoldersView.swift
//  Janitor
//
//  Created by Ben Leggiero on 7/18/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import JanitorKit



struct AllWatchedFoldersView: View {
    
    @Binding
    var trackedDirectories: [TrackedDirectory]
    
    @Binding
    var currentlyEditedDirectory: TrackedDirectory?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                ForEach(trackedDirectories) { trackedDirectory in
                    WatchedFolderView(
                        trackedDirectory: Binding(
                            get: { self.trackedDirectories[trackedDirectory.id] ?? trackedDirectory },
                            set: { self.trackedDirectories.replaceOrAppend($0) }),
                        onDidPressEditButton:   { self.currentlyEditedDirectory = trackedDirectory },
                        onDidPressDeleteButton: { self.trackedDirectories.remove(firstElementWithId: trackedDirectory.id) }
                    )
                }
            }
        }
        .frame(minHeight: 100)
    }
}

#if DEBUG
struct AllWatchedFoldersSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AllWatchedFoldersView(trackedDirectories: .constant([.default()]),
                              currentlyEditedDirectory: .constant(nil)
        )
    }
}
#endif
