//
//  TrackedDirectoriesView.swift
//  Janitor
//
//  Created by Ky Leggiero on 2021-07-17.
//

import SwiftUI

import JanitorKit



struct TrackedDirectoriesView: View {
    
    @Binding
    var trackedDirectories: [TrackedDirectory]
    
    
    init(_ trackedDirectories: Binding<[TrackedDirectory]>) {
        self._trackedDirectories = trackedDirectories
    }
    
    
    var body: some View {
        List(trackedDirectories) { dir in
            Text(dir.url.absoluteString)
        }
        .listStyle(InsetListStyle())
    }
}



struct TrackedDirectoriesView_Previews: PreviewProvider {
    static var previews: some View {
        TrackedDirectoriesView(.constant([
            .init(uuid: UUID(),
                  isEnabled: true,
                  url: URL(fileURLWithPath: "/Path/To/File"),
                  oldestAllowedAge: Age(value: 30, unit: .day),
                  largestAllowedTotalSize: DataSize(value: 1, unit: .gibibyte))
        ]))
    }
}
