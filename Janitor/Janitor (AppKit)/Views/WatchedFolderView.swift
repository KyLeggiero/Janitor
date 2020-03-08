//
//  WatchedFolderView.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-06.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa
import JanitorKit
import CrossKitTypes



class WatchedFolderView: View {
    
    var trackedDirectory: TrackedDirectory {
        didSet { rebuild() }
    }
    
    
    init(trackedDirectory: TrackedDirectory) {
        self.trackedDirectory = trackedDirectory
        super.init()
    }
    
    
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) is not supported by this View")
    }
    
    
    var body: some NSView {
        NSBox(title: nil, padding: NSEdgeInsets(eachVertical: 6, eachHorizontal: 10)) {
            VStack(alignment: .leading) {
                NSTextField(labelWithAttributedString: configurationDescription)
                NSPathControl(trackedDirectory.url)
                    .enabled(false)
            }
            .huggingPriority(.required, for: .vertical)
        }
        .huggingPriority(.required, for: .vertical)
    }
    
    
    var configurationDescription: NSAttributedString {
        let mutableString = NSMutableAttributedString()
        mutableString.append(NSAttributedString(string: trackedDirectory.oldestAllowedAge.description))
        mutableString.append(NSAttributedString(string: " – ", attributes: [.foregroundColor : NativeColor.secondaryLabelColor]))
        mutableString.append(NSAttributedString(string: trackedDirectory.largestAllowedTotalSize.description))
        return mutableString
    }
}
