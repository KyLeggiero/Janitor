//
//  EditTrackedDirectorySheet.swift
//  EditTrackedDirectorySheet
//
//  Created by Ky Leggiero on 2021-07-25.
//

import SwiftUI

import JanitorKit



struct EditTrackedDirectorySheet: ViewModifier {
    
    @Binding
    private var trackedDirectory: TrackedDirectory
    
    @Binding
    private var isEditing: Bool
    
    
    init(trackedDirectory: Binding<TrackedDirectory>, isEditing: Binding<Bool>) {
        self._trackedDirectory = trackedDirectory
        self._isEditing = isEditing
    }
    
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isEditing, onDismiss: nil) {
                TrackedDirectoryConfigurationView(for: $trackedDirectory, onDone: { isEditing = false })
            }
    }
}



extension View {
    
    /// When `isEditing` is `true`, this presents a sheet to edit that directory. Edits are applied directly to the tracked directory binding you pass here.
    ///
    /// - Parameters:
    ///   - trackedDirectory: The directory to edit
    ///   - isEditing:        Whether the directory is currently being edited
    func editTrackedDirectory(_ trackedDirectory: Binding<TrackedDirectory>, isEditing: Binding<Bool>) -> some View {
        self.modifier(EditTrackedDirectorySheet(trackedDirectory: trackedDirectory,
                                                isEditing: isEditing))
    }
}
