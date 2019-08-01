//
//  NewWatchedFolderSetupView.swift
//  Janitor
//
//  Created by Ben Leggiero on 7/19/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import JanitorKit



struct NewWatchedFolderSetupView: View {
    
    var onComplete: OnComplete
//    @State var selectedFile: URL? = nil
//    @State var age: Age = 30.days
    
    @Inout
    var trackedDirectory: TrackedDirectory
    
    @BoundPointer
    private var trackedDirectory_url: URL? = nil

    @BoundPointer
    private var trackedDirectory_oldestAllowedAge: Age

    @BoundPointer
    private var trackedDirectory_largestAllowedTotalSize: DataSize
    
    var body: some View {
        VStack {
            Text("Add a folder to the cleaning schedule")
            SelectFileControl(selectedFile: _trackedDirectory_url.binding)
            MeasurementPicker(preamble: "No file older than", measurement: _trackedDirectory_oldestAllowedAge.binding, postamble: nil)
            MeasurementPicker(preamble: "Overall no more than", measurement: _trackedDirectory_largestAllowedTotalSize.binding, postamble: nil)
            HStack {
                Spacer()
                Button("Cancel", action: didPressCancel)
                Button("Save", action: didPressSave)
                    .buttonStyle(.default)
            }
        }
    }
    
    init(trackedDirectory: Binding<TrackedDirectory>, onComplete: @escaping OnComplete) {
        self._trackedDirectory = trackedDirectory
        self.onComplete = onComplete
        
        self._trackedDirectory_url = .init(initialValue: trackedDirectory.value.url)
        self._trackedDirectory_oldestAllowedAge = .init(initialValue: trackedDirectory.value.oldestAllowedAge)
        self._trackedDirectory_largestAllowedTotalSize = .init(initialValue: trackedDirectory.value.largestAllowedTotalSize)
        
        self._trackedDirectory_url.didSet = setTrackedDirectoryUrlOnPointerDidSet
        self._trackedDirectory_oldestAllowedAge.didSet = setTrackedDirectoryOldestAllowedAge
        self._trackedDirectory_largestAllowedTotalSize.didSet = setTrackedDirectoryLargestAllowedTotalSize
    }
    
    
    func didPressSave() {
        self.onComplete(trackedDirectory)
    }
    
    
    func didPressCancel() {
        self.onComplete(nil)
    }
    
    
    
    typealias OnComplete = (TrackedDirectory?) -> Void
}



private extension NewWatchedFolderSetupView {
    
    nonmutating func setTrackedDirectoryUrlOnPointerDidSet(newValue: URL?) {
        if let url = newValue {
            self.trackedDirectory.url = url
        }
    }
    
    
    nonmutating func setTrackedDirectoryOldestAllowedAge(newValue: Age) {
        self.trackedDirectory.oldestAllowedAge = newValue
    }
    
    
    nonmutating func setTrackedDirectoryLargestAllowedTotalSize(newValue: DataSize) {
        self.trackedDirectory.largestAllowedTotalSize = newValue
    }
}



#if DEBUG
struct NewWatchedFolderSetupView_Previews: PreviewProvider {
    static var previews: some View {
        NewWatchedFolderSetupView(trackedDirectory: .constant(.default), onComplete: { _ in })
    }
}
#endif
