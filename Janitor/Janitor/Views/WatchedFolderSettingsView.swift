//
//  WatchedFolderSettingsView.swift
//  Janitor
//
//  Created by Ben Leggiero on 7/18/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import AppKit
import JanitorKit



struct WatchedFolderSettingsView: View {
    
    @Inout
    var trackedDirectory: TrackedDirectory

    var onDidPressEditButton: OnDidPressEditButton
    var onDidPressDeleteButton: OnDidPressDeleteButton
    
    @State
    private var isPopoverShown = false
    
    private var isEnabledCheckboxState: Inout<Checkbox.State>
    
    init(trackedDirectory: Inout<TrackedDirectory>,
         onDidPressEditButton: @escaping OnDidPressEditButton,
         onDidPressDeleteButton: @escaping OnDidPressDeleteButton) {
        
        self.onDidPressEditButton = onDidPressEditButton
        self.onDidPressDeleteButton = onDidPressDeleteButton
        
        self._trackedDirectory = trackedDirectory
        
        self.isEnabledCheckboxState = .constant(.indeterminate)
        self.isEnabledCheckboxState = Inout(
            getValue: checkBoxStateBasedOnEnabled,
            setValue: updateEnabledBasedOnCheckboxState
        )
    }
    
    
    var body: some View {
        VStack {
            HStack {
                Text(trackedDirectory.url.lastPathComponent)
                Text(" – ")
                    .foregroundColor(.secondary)
                Text(trackedDirectory.oldestAllowedAge.description)
                Text(" – ")
                    .foregroundColor(.secondary)
                Text(trackedDirectory.largestAllowedTotalSize.description)
                Button("􀁜", action: { self.isPopoverShown.toggle() })
                    .buttonStyle(.plain)
                    .popover(isPresented: $isPopoverShown, content: popoverContent)
                
                Spacer(minLength: 8)
                
                Button("􀈊", action: didPressEditButton)
                    .buttonStyle(.plain)
                Button("􀈑", action: didPressDeleteButton)
                    .buttonStyle(.plain)
            }
            
            HStack {
                PathControlView(url: trackedDirectory.url)
                    .frame(minWidth: 100, idealWidth: 200, minHeight: 16, idealHeight: 16, alignment: .leading)
                
                Checkbox(title: "Disabled", alternateTitle: "Enabled", state: isEnabledCheckboxState, alignment: .checkboxTrailing)
            }
        }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .border(Color.watchedFolderSettingsBorder, cornerRadius: 6)
            .background(Color.watchedFolderSettingsBackground)
            .cornerRadius(6)
    }
    
    
    private func checkBoxStateBasedOnEnabled() -> Checkbox.State {
        return .init(self.trackedDirectory.isEnabled)
    }
    
    
    private func updateEnabledBasedOnCheckboxState(_ newState: Checkbox.State) {
        switch newState {
        case .checked:
            self.trackedDirectory.isEnabled = true
            
        case .unchecked, .indeterminate:
            self.trackedDirectory.isEnabled = false
        }
    }
    
    
    public func popoverContent() -> some View {
        VStack {
            HStack(spacing: 4) {
                Text("Items in the")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(self.trackedDirectory.url.lastPathComponent)
                    .font(Font.caption.weight(.black))
                Text("folder")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            HStack(spacing: 4) {
                Text("will be trashed if they are older than")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(self.trackedDirectory.oldestAllowedAge.description)
                    .font(Font.caption.weight(.black))
            }
            HStack(spacing: 4) {
                Text("or if they push the folder's total size over")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(self.trackedDirectory.largestAllowedTotalSize.description)
                    .font(Font.caption.weight(.black))
            }
        }
        .padding()
    }
    
    
    private func didPressEditButton() {
        onDidPressEditButton()
    }
    
    
    private func didPressDeleteButton() {
        onDidPressDeleteButton()
    }
    
    
    
    typealias OnDidPressEditButton = () -> Void
    typealias OnDidPressDeleteButton = () -> Void
}

#if DEBUG
struct WatchedFolderSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        WatchedFolderSettingsView(trackedDirectory: .constant(TrackedDirectory(url: URL.User.desktop!,
                                                                     oldestAllowedAge: 1.weeks,
                                                                     largestAllowedTotalSize: 2.gibibytes)),
                                  onDidPressEditButton: {},
                                  onDidPressDeleteButton: {}
        )
    }
}
#endif
