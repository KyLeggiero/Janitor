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
    private var isSelectingNewDirectoryToTrack = false
    
    @State
    private var nextTrackedDirectory: TrackedDirectory?
    
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
                TrackedDirectoryView(dir)
            }
            .onDelete { self.trackedDirectories.remove(atOffsets: $0) }
        }
        .listStyle(InsetListStyle())
        .frame(minWidth: 400, idealWidth: 400, minHeight: 200, idealHeight: 300)
        
        
        .toolbar(id: "TrackedDirectoriesView") {
            ToolbarItem(id: "Track a new directory", placement: .primaryAction, showsByDefault: true) {
                Button(action: { isSelectingNewDirectoryToTrack = true }) {
                    Image(systemName: "plus")
                    Text("Track another")
                }
                .controlSize(.large)
            }
        }
        
        
        .fileImporter(isPresented: $isSelectingNewDirectoryToTrack,
                      allowedContentTypes: [.directory]) { result in
            switch result {
            case .success(let directoryUrl):
                nextTrackedDirectory = .init(
                    uuid: UUID(),
                    isEnabled: true,
                    url: directoryUrl,
                    oldestAllowedAge: .init(value: 60, unit: .day),
                    largestAllowedTotalSize: .init(value: 5, unit: .gibibyte))
                
            case .failure(let error):
                log(error: error)
                assertionFailure()
            }
        }
        
        
        .sheet(item: $nextTrackedDirectory) { newTrackedDirectory in
            TrackedDirectoryConfigurationView(
                for: .init(
                    get: { newTrackedDirectory },
                    set: { self.trackedDirectories += $0 }
                ),
                onDone: {
                    self.nextTrackedDirectory = nil
                }
            )
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
