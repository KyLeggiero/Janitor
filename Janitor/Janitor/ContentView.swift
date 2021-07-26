//
//  ContentView.swift
//  Janitor
//
//  Created by Ky Leggiero on 2021-07-17.
//

import SwiftUI
import SwiftyUserDefaults



struct ContentView: View {
    
    @SwiftyUserDefault(keyPath: \.trackedDirectories)
    var trackedDirectories
    
    
    var body: some View {
        TrackedDirectoriesView(.init(
            get: { self.trackedDirectories },
            set: { self.trackedDirectories = $0 })
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
