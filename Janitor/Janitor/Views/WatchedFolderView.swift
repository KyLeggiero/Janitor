//
//  WatchedFolderView.swift
//  Janitor
//
//  Created by Ben Leggiero on 7/18/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import AppKit
import JanitorKit



struct WatchedFolderView: View {
    
    @Binding
    var trackedDirectory: TrackedDirectory

    var onDidPressEditButton: OnDidPressEditButton
    var onDidPressDeleteButton: OnDidPressDeleteButton
    
    @State
    private var isPopoverShown = false
    
    init(trackedDirectory: Binding<TrackedDirectory>,
         onDidPressEditButton: @escaping OnDidPressEditButton,
         onDidPressDeleteButton: @escaping OnDidPressDeleteButton) {
        
        self.onDidPressEditButton = onDidPressEditButton
        self.onDidPressDeleteButton = onDidPressDeleteButton
        
        self._trackedDirectory = trackedDirectory
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
                    .buttonStyle(PlainButtonStyle())
                    .popover(isPresented: $isPopoverShown, content: popoverContent)
                
                Spacer(minLength: 8)
                
                Button("􀈊", action: didPressEditButton)
                    .buttonStyle(PlainButtonStyle())
                Button("􀈑", action: didPressDeleteButton)
                    .buttonStyle(PlainButtonStyle())
            }
            
            HStack {
                PathControlView(url: trackedDirectory.url)
                    .frame(minWidth: 100, idealWidth: 200, minHeight: 16, idealHeight: 16, alignment: .leading)
                
                Toggle(
                    isOn: Binding(
                        get: { self.trackedDirectory.isEnabled },
                        set: { self.trackedDirectory.isEnabled = $0 }
                    ),
                    label: { Text(self.trackedDirectory.isEnabled ? "Enabled" : "Disabled") })
//                Checkbox(title: "Disabled", alternateTitle: "Enabled", state: isEnabledCheckboxState, alignment: .checkboxTrailing)
            }
        }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
//            .border(Color.watchedFolderSettingsBorder)
//            .clipShape(RoundedRectangle(cornerRadius: 6, style: RoundedCornerStyle.circular))
//            .contentShape(RoundedRectangle(cornerRadius: 6, style: RoundedCornerStyle.circular))
//            .border(Color.watchedFolderSettingsBorder, cornerRadius: 6)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(Color.watchedFolderSettingsBorder)
                    .background(Color.watchedFolderSettingsBackground)
                    .cornerRadius(6)
            )
//            .background(RoundedRectangle(cornerRadius: 6, style: .circular)
//                .fill(Color.watchedFolderSettingsBackground)
//                .border(Color.watchedFolderSettingsBorder)
//            )
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
        WatchedFolderView(trackedDirectory: .constant(.default()),
                                  onDidPressEditButton: {},
                                  onDidPressDeleteButton: {}
        )
    }
}
#endif
