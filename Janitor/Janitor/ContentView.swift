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
        if trackedDirectories?.isEmpty ?? true {
            VStack {
                HStack {
                    TrackNewDirectoryButton(trackedDirectories: .init(
                        get: { trackedDirectories ?? [] },
                        set: { self.trackedDirectories = $0 })
                    )
                }
            }
        }
        else {
            TrackedDirectoriesView(.init(
                get: { trackedDirectories ?? [] },
                set: { self.trackedDirectories = $0 })
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
