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
    @State var selectedFile: URL? = nil
    @State var age: Age = 30.days
    
    var body: some View {
        VStack {
            Text("Add a folder to the cleaning schedule")
            SelectFileControl(selectedFile: $selectedFile)
            MeasurementPicker(preamble: "No older than", measurement: $age, postamble: nil)
            HStack {
                Spacer()
                Button("Cancel", action: didPressCancel)
                Button("Save", action: didPressSave)
                    .buttonStyle(.default)
            }
        }
    }
    
    var trackedDirectory: TrackedDirectory? {
        guard let url = self.selectedFile else {
            return nil
        }
        return TrackedDirectory(url: url, oldestAllowedAge: 30.days, largestAllowedTotalSize: 1.gibibytes)
    }
    
    
    func didSelectFile(_ file: URL?) {
        self.selectedFile = file
    }
    
    
    func didPressSave() {
        self.onComplete(trackedDirectory)
    }
    
    
    func didPressCancel() {
        self.onComplete(nil)
    }
    
    
    
    typealias OnComplete = (TrackedDirectory?) -> Void
}

#if DEBUG
struct NewWatchedFolderSetupView_Previews: PreviewProvider {
    static var previews: some View {
        NewWatchedFolderSetupView(onComplete: { _ in })
    }
}
#endif
