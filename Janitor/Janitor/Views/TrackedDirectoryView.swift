//
//  TrackedDirectoryView.swift
//  TrackedDirectoryView
//
//  Created by Ben Leggiero on 2021-07-18.
//

import SwiftUI

import JanitorKit



private let hoverAnimation = Animation.spring()//.easeInOut(duration: 0.25)



struct TrackedDirectoryView: View {
    
    @Binding
    private var trackedDirectory: TrackedDirectory
    
    @State
    private var isEditing = false
    
    private let onDeleteRequested: BlindCallback
    
    @State
    private var isHovering = false
    
    
    init(_ trackedDirectory: Binding<TrackedDirectory>, onDeleteRequested: @escaping BlindCallback) {
        self._trackedDirectory = trackedDirectory
        self.onDeleteRequested = onDeleteRequested
    }
    
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            if isHovering {
                Button(action: { isEditing = true }) {
                    Image(systemName: "slider.horizontal.3")
                }
                .buttonStyle(LinkButtonStyle())
                .transition(.opacity)
            }
            
            DecorativeUrlView(trackedDirectory.url)
                .fixedSize()
            
            MeasurementView(trackedDirectory.largestAllowedTotalSize)
                .fixedSize()
            
            MeasurementView(trackedDirectory.oldestAllowedAge)
                .fixedSize()
            
            Spacer()
            
            Toggle("Automatically clean this directory", isOn: $trackedDirectory.isEnabled)
                .toggleStyle(SwitchToggleStyle(tint: .toggle))
                .labelsHidden()
        }
        
        .animation(hoverAnimation, value: isHovering)
        .frame(minHeight: 32)
        
        .editTrackedDirectory($trackedDirectory, isEditing: $isEditing)
        
        .contextMenu {
            Button("Delete", action: onDeleteRequested)
        }
        
        .onHover(perform: { isHovering = $0 })
    }
}



struct TrackedDirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        TrackedDirectoryView(
            .constant(.init(
                uuid: UUID(),
                isEnabled: true,
                url: URL(fileURLWithPath: "/Path/To/File.txt"),
                oldestAllowedAge: .init(value: 7, unit: .day),
                largestAllowedTotalSize: .init(value: 2, unit: .gibibyte))),
            onDeleteRequested: null
        )
    }
}
