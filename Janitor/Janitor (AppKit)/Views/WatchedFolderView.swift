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
import SafePointer



class WatchedFolderView: View {
    
    var trackedDirectory: TrackedDirectory {
        didSet { rebuild() }
    }
    
    @ObservableMutableSafePointer
    var isPopoverShown = false
    
    private let onEditPressed: OnEditPressed
    
    
    init(trackedDirectory: TrackedDirectory, onEditPressed: @escaping OnEditPressed) {
        self.trackedDirectory = trackedDirectory
        self.onEditPressed = onEditPressed
        super.init()
        self._isPopoverShown.addObserver { (_, _) in
            self.updateDisplay(ofPopoverWithId: "info")
        }
    }
    
    
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) is not supported by this View")
    }
    
    
    var body: some NSView {
        NSBox(title: nil, padding: NSEdgeInsets(eachVertical: 0, eachHorizontal: 4)) {
            VStack(alignment: .leading) {
                HStack {
                    NSTextField(labelWithAttributedString: configurationDescription)
                    Button("􀁜", action: didPressInfoButton)
                        .borderless()
                        .popover(withId: "info", parent: self, isPresented: _isPopoverShown, content: popoverContent)
                    
                    Spacer()
                    Button("􀈊", action: didPressEditButton)
                        .borderless()
                    Button("􀈑", action: didPressDeleteButton)
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
    
    
    
    typealias OnEditPressed = (ObservableSafeMutablePointer<TrackedDirectory>) -> Void
}



private extension WatchedFolderView {
    @IBAction
    func didPressInfoButton(sender _: NSButton) {
        isPopoverShown.toggle()
    }
    
    
    @IBAction
    func didPressEditButton(sender _: NSButton) {
        onEditPressed(ObservableSafeMutablePointer(to: trackedDirectory) { _, new in
            self.trackedDirectory = new
        })
    }
    
    
    @IBAction
    func didPressDeleteButton(sender _: NSButton) {
        print("Delete")
    }
}



private extension WatchedFolderView {
    func popoverContent() -> some NSView {
        NSTextField {
            "Items in the "
                .font(.caption)
                .foregroundColor(.secondaryLabelColor)
            
            trackedDirectory.url.lastPathComponent
                .font(NativeFont.caption.weight(.black))
            
            " folder will be trashed\nif they are older than "
                .font(.caption)
                .foregroundColor(.secondaryLabelColor)
            
            trackedDirectory.oldestAllowedAge.description
                .font(NativeFont.caption.weight(.black))
            
            "\nor if all items together total more than "
                .font(.caption)
                .foregroundColor(.secondaryLabelColor)
            
            trackedDirectory.largestAllowedTotalSize.description
                .font(NativeFont.caption.weight(.black))
        }
        .allowTextWrapping(true)
        .padding()
    }
}
