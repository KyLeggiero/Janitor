//
//  TrackedDirectoryView.swift
//  TrackedDirectoryView
//
//  Created by Ben Leggiero on 2021-07-18.
//

import SwiftUI
import JanitorKit



struct TrackedDirectoryView: View {
    
    @Binding
    var trackedDirectory: TrackedDirectory
    
    
    init(_ trackedDirectory: Binding<TrackedDirectory>) {
        self._trackedDirectory = trackedDirectory
    }
    
    
    var body: some View {
        HStack {
            DecorativeUrlView(trackedDirectory.url)
            
            Spacer()
            
            Toggle("Clean this directory", isOn: $trackedDirectory.isEnabled)
                .toggleStyle(SwitchToggleStyle(tint: .toggle))
                .labelsHidden()
        }
        .frame(minHeight: 32)
    }
}

struct TrackedDirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        TrackedDirectoryView(.constant(.init(
            uuid: UUID(),
            isEnabled: true,
            url: URL(fileURLWithPath: "/Path/To/File.txt"),
            oldestAllowedAge: .init(value: 7, unit: .day),
            largestAllowedTotalSize: .init(value: 2, unit: .gibibyte))))
    }
}
