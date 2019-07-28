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
    
    @Binding
    var trackedDirectories: [TrackedDirectory]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                ForEach(_trackedDirectories) { trackedDirectory in
                    WatchedFolderSettingsView(trackedDirectory: trackedDirectory,
                                              onDidPressEditButton: { edit(trackedDirectory) },
                                              onDidPressDeleteButton: { delete(trackedDirectory) })
                }
            }
        }
        .frame(minHeight: 100)
    }
    
    
    func edit(_ trackedDirectory: TrackedDirectory) {
        // TODO
    }
    
    
    func delete(_ trackedDirectory: TrackedDirectory) {
        // TODO
    }
}

#if DEBUG
struct AllWatchedFoldersSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AllWatchedFoldersSettingsView(trackedDirectories: .constant([
            TrackedDirectory(url: URL.User.downloads!, oldestAllowedAge: 30.days, largestAllowedTotalSize: 1.gibibytes)
        ]))
    }
}
#endif
