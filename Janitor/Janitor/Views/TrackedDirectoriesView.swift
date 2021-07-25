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
    var trackedDirectories: [TrackedDirectory]
    
    @State
    private var isSelectingNewDirectoryToTrack = false
    
    @State
    private var nextTrackedDirectory: TrackedDirectory? = TrackedDirectory(
        uuid: UUID(),
        isEnabled: true,
        url: URL(fileURLWithPath: "/Users/benleggiero/Downloads/"),
        oldestAllowedAge: Age(value: 123, unit: .day),
        largestAllowedTotalSize: DataSize(value: 456, unit: .mebibyte))
    
    
    init(_ trackedDirectories: Binding<[TrackedDirectory]>) {
        self._trackedDirectories = trackedDirectories
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            List($trackedDirectories) { dir in
                TrackedDirectoryView(dir)
            }
            .listStyle(InsetListStyle())
            
            Divider()
            
            Spacer(minLength: 0).fixedSize()
            
            HStack {
                Button(action: { isSelectingNewDirectoryToTrack = true }) {
//                    HStack {
                        Image(systemName: "plus")
                        Text("Track another")
//                    }
                }
                .padding()
            }
            .controlSize(.large)
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
            TrackedDirectoryConfigurationView(for: .init(
                get: { newTrackedDirectory },
                set: { self.trackedDirectories += $0 } )) {
                    self.nextTrackedDirectory = nil
            }
        }
    }
}



private extension TrackedDirectoriesView {
    func selectNewDirectoryToTrack() {
        
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
