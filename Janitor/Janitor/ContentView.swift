//
//  ContentView.swift
//  Janitor
//
//  Created by Ky Leggiero on 2021-07-17.
//

import SwiftUI
import SwiftyUserDefaults
import JanitorKit



struct ContentView: View {
    
    @Binding
    private var trackedDirectories: [TrackedDirectory]
    
    
    init(trackedDirectories: Binding<[TrackedDirectory]>) {
        self._trackedDirectories = trackedDirectories
    }
    
    
    var body: some View {
        TrackedDirectoriesView($trackedDirectories)
    }
}

struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView(trackedDirectories: .example)
    }
}
