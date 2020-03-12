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
import AttributedStringBuilder



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
        NSBox(title: nil, padding: NSEdgeInsets(eachVertical: 0, eachHorizontal: 4)) {
            VStack(alignment: .leading) {
                HStack {
                    NSTextField(labelWithAttributedString: configurationDescription)
                    NSButton(title: "􀁜", target: self, action: #selector(didPressInfoButton))
                        .borderless()
                    Spacer()
                    NSButton(title: "􀈊", target: self, action: #selector(didPressEditButton))
                        .borderless()
                    NSButton(title: "􀈑", target: self, action: #selector(didPressDeleteButton))
                        .borderless()
                }
                NSPathControl(trackedDirectory.url)
                    .enabled(false)
            }
            .huggingPriority(.required, for: .vertical)
        }
        .huggingPriority(.required, for: .vertical)
    }
    
    
    var configurationDescription: NSAttributedString {
        NSAttributedString {
            trackedDirectory.url.lastPathComponent
                .font(NativeFont.boldSystemFont(ofSize: NativeFont.systemFontSize))
            
            " – ".foregroundColor(.secondaryLabelColor)
            
            trackedDirectory.oldestAllowedAge.description
            
            " – ".foregroundColor(.secondaryLabelColor)
            
            trackedDirectory.largestAllowedTotalSize.description
        }
    }
}



private extension WatchedFolderView {
    @IBAction
    func didPressInfoButton(sender _: NSButton) {
        print("Info")
    }
    
    
    @IBAction
    func didPressEditButton(sender _: NSButton) {
        print("Edit")
    }
    
    
    @IBAction
    func didPressDeleteButton(sender _: NSButton) {
        print("Delete")
    }
}
