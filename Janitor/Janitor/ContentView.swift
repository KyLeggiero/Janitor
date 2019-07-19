//
//  ContentView.swift
//  Janitor
//
//  Created by Ben Leggiero on 7/17/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var watchedLocations: [URL]
    
    var body: some View {
        VStack {
            AllWatchedFoldersSettingsView(watchedLocations: watchedLocations)
            AddNewWatchedFolderView()
        }
    }
}


#if DEBUG
struct ContentView_Previews: PreviewProvider {
    
    static let exampleUrls = [
        URL.User.desktop!,
        URL.User.downloads!,
    ]
    
    static var previews: some View {
        ContentView(watchedLocations: exampleUrls)
    }
}
#endif
