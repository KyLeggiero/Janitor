//
//  TrackedDirectoryConfigurationView.swift
//  Janitor
//
//  Created by Ky Leggiero on 2021-07-19.
//

import SwiftUI

import FunctionTools
import JanitorKit



struct TrackedDirectoryConfigurationView: View {
    
    @Binding
    var trackedDirectory: TrackedDirectory
    
    let onSubmit: Callback<TrackedDirectory?>
    
    
    init(for trackedDirectory: Binding<TrackedDirectory>,
         onSubmit: @escaping Callback<TrackedDirectory?>)
    {
        self._trackedDirectory = trackedDirectory
        self.onSubmit = onSubmit
    }
    
    
    var body: some View {
        Text(trackedDirectory.url.actualPath)
    }
}



struct TrackeedDirectoryConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        TrackeedDirectoryConfigurationView(
            for: .constant(
                TrackedDirectory(
                    uuid: UUID(),
                    isEnabled: true,
                    url: URL(fileURLWithPath: "/Users/kyleggiero/Downloads"),
                    oldestAllowedAge: Age(value: 30, unit: .day),
                    largestAllowedTotalSize: DataSize(value: 30, unit: .gibibyte)
                )
            ),
               onSubmit: { _ in }
        )
    }
}
