//
//  TrackedDirectoriesView.swift
//  Janitor
//
//  Created by Ky Leggiero on 2021-07-17.
//

import SwiftUI

import CollectionTools
import JanitorKit
import SimpleLogging



struct TrackedDirectoriesView: View {
    
    @Binding
    private var trackedDirectories: [TrackedDirectory]
    
    @State
    private var isEditing = false
    
    @State
    private var selectedDirectory: TrackedDirectory?
    
    
    init(_ trackedDirectories: Binding<[TrackedDirectory]>) {
        self._trackedDirectories = trackedDirectories
    }
    
    
    var body: some View {
        List {
            ForEach($trackedDirectories) { dir in
                TrackedDirectoryView(dir, onDeleteRequested: { trackedDirectories.remove(firstElementWithId: dir.id) })
            }
            .onDelete { self.trackedDirectories.remove(atOffsets: $0) }
        }
        .listStyle(InsetListStyle())
        .frame(minWidth: 400, idealWidth: 400, minHeight: 200, idealHeight: 300)
        
        
        .toolbar(id: "TrackedDirectoriesView") {
            ToolbarItem(id: "Track a new directory", placement: .primaryAction, showsByDefault: true) {
                TrackNewDirectoryButton(trackedDirectories: $trackedDirectories)
            }
        }
    }
}



struct TrackedDirectoriesView_Previews: PreviewProvider {
    static var previews: some View {
        TrackedDirectoriesView(.constant([
            .init(uuid: UUID(),
                  isEnabled: true,
                  url: URL(fileURLWithPath: "/Path/To/File1"),
                  oldestAllowedAge: Age(value: 30, unit: .day),
                  largestAllowedTotalSize: DataSize(value: 1, unit: .gibibyte)),
            .init(uuid: UUID(),
                  isEnabled: false,
                  url: URL(fileURLWithPath: "/Path/To/File2"),
                  oldestAllowedAge: Age(value: 30, unit: .day),
                  largestAllowedTotalSize: DataSize(value: 1, unit: .gibibyte)),
        ]))
    }
}
