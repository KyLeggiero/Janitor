//
//  AllWatchedFoldersSettingsView.swift
//  Janitor
//
//  Created by Ben Leggiero on 7/18/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI

struct AllWatchedFoldersSettingsView: View {
    
    var watchedLocations: [URL]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                ForEach(watchedLocations, id: \URL.absoluteString) { location in
                    WatchedFolderSettingsView(url: location, isEnabled: .constant(true))
                }
            }
        }
        .frame(minHeight: 100)
    }
}

#if DEBUG
struct AllWatchedFoldersSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AllWatchedFoldersSettingsView(watchedLocations: [URL.User.downloads!])
    }
}
#endif
