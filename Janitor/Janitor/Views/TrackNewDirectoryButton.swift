//
//  TrackNewDirectoryButton.swift
//  TrackNewDirectoryButton
//
//  Created by Ky Leggiero on 2021-07-25.
//

import SwiftUI

import CollectionTools
import JanitorKit
import SimpleLogging



struct TrackNewDirectoryButton: View {
    
    @State
    private var isSelectingNewDirectoryToTrack = false
    
    @State
    private var nextTrackedDirectory: TrackedDirectory?
    
    @Binding
    private var trackedDirectories: [TrackedDirectory]
    
    
    public init(trackedDirectories: Binding<[TrackedDirectory]>) {
        self._trackedDirectories = trackedDirectories
    }
    
    
    var body: some View {
        Button(action: { isSelectingNewDirectoryToTrack = true }) {
            Image(systemName: "plus")
            Text("Track another")
        }
        .controlSize(.large)
        
        
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

struct TrackNewDirectoryButton_Previews: PreviewProvider {
    static var previews: some View {
        TrackNewDirectoryButton(trackedDirectories: .constant([]))
    }
}
