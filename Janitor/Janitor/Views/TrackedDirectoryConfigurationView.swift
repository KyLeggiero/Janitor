//
//  TrackedDirectoryConfigurationView.swift
//  Janitor
//
//  Created by Ky Leggiero on 2021-07-19.
//

import SwiftUI

import FunctionTools
import SimpleLogging
import JanitorKit



struct TrackedDirectoryConfigurationView: View {
    
    @State
    private var workingTrackedDirectory: TrackedDirectory
    
    @Binding
    private var inoutTrackedDirectory: TrackedDirectory
    
    @State
    private var isSelectingNewDirectoryToTrack = false
    
    private let onDone: BlindCallback
    
    
    init(for trackedDirectory: Binding<TrackedDirectory>,
         onDone: @escaping BlindCallback)
    {
        self._inoutTrackedDirectory = trackedDirectory
        self._workingTrackedDirectory = State(initialValue: trackedDirectory.wrappedValue)
        self.onDone = onDone
    }
    
    
    var body: some View {
        VStack {
            VStack {
                HStack(alignment: .top) {
                    Button(action: { isSelectingNewDirectoryToTrack = true }) {
                        DecorativeUrlView(workingTrackedDirectory.url)
                            .fixedSize()
                    }
                    .buttonStyle(LinkButtonStyle())
                    .padding(.bottom)
                    
                    Spacer(minLength: 100)
                    
                    Toggle("Enabled", isOn: $workingTrackedDirectory.isEnabled)
                        .fixedSize()
                        .toggleStyle(SwitchToggleStyle(tint: .green))
                }
                
                Form {
                    MeasurementPicker("Oldest Allowed Age",
                                      selection: $workingTrackedDirectory.oldestAllowedAge,
                                      valueRange: Age(value: 1, unit: .minute) ... Age(value: 50, unit: .year))
                        .fixedSize()
                    
                    MeasurementPicker("Largest Total Size",
                                      selection: $workingTrackedDirectory.largestAllowedTotalSize,
                                      valueRange: DataSize(value: 56, unit: .kilobyte) ... DataSize(value: 1, unit: .exbibyte))
                        .fixedSize()
                }
            }
            .padding()
            
            Divider()
            
            HStack(alignment: .lastTextBaseline) {
                Spacer()
                
                Button("Cancel", action: onDone)
                    .keyboardShortcut(.cancelAction)
                
                Button("Start Tracking", action: {
                    inoutTrackedDirectory = workingTrackedDirectory
                    onDone()
                })
                    .keyboardShortcut(.defaultAction)
                    .controlSize(.large)
            }
            .padding([.horizontal, .bottom])
        }
        .fileImporter(isPresented: $isSelectingNewDirectoryToTrack,
                      allowedContentTypes: [.directory]) { result in
            switch result {
            case .success(let directoryUrl):
                workingTrackedDirectory.url = directoryUrl
                
            case .failure(let error):
                log(error: error)
                assertionFailure()
            }
        }
    }
}



struct TrackeedDirectoryConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        TrackedDirectoryConfigurationView(
            for: .constant(
                TrackedDirectory(
                    uuid: UUID(),
                    isEnabled: true,
                    url: URL(fileURLWithPath: "/Users/kyleggiero/Downloads"),
                    oldestAllowedAge: Age(value: 30, unit: .day),
                    largestAllowedTotalSize: DataSize(value: 30, unit: .gibibyte)
                )
            ),
               onDone: null
        )
    }
}
