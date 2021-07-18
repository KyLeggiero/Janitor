//
//  WatchedFolderEditView.swift
//  Janitor
//
//  Created by Ben Leggiero on 7/19/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import JanitorKit



struct WatchedFolderEditView: View {
    
    var onComplete: OnComplete
//    @State var selectedFile: URL? = nil
//    @State var age: Age = 30.days
    
    @Binding
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
            MeasurementPicker(preamble: "No file older than", measurement: _trackedDirectory_oldestAllowedAge.binding, presentedUnits: Age.Unit.commonFileAgeCases, postamble: nil)
            MeasurementPicker(preamble: "Overall no more than", measurement: _trackedDirectory_largestAllowedTotalSize.binding, presentedUnits: DataSize.Unit.commonSIFileSizeCases, postamble: nil)
            HStack {
                Spacer()
                Button("Cancel", action: didPressCancel)
                Button("Save", action: didPressSave)
                    .buttonStyle(BorderedButtonStyle())
            }
        }
    }
    
    init(trackedDirectory: Binding<TrackedDirectory>, onComplete: @escaping OnComplete) {
        self._trackedDirectory = trackedDirectory
        self.onComplete = onComplete
        
        self._trackedDirectory_url = .init(wrappedValue: trackedDirectory.wrappedValue.url)
        self._trackedDirectory_oldestAllowedAge = .init(wrappedValue: trackedDirectory.wrappedValue.oldestAllowedAge)
        self._trackedDirectory_largestAllowedTotalSize = .init(wrappedValue: trackedDirectory.wrappedValue.largestAllowedTotalSize)
        
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



private extension WatchedFolderEditView {
    
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
        WatchedFolderEditView(trackedDirectory: .constant(.default()), onComplete: { _ in })
    }
}
#endif
