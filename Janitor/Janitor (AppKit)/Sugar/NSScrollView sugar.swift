//
//  NSScrollView sugar.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-06.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa
import CrossKitTypes



public extension NSScrollView {
    convenience init(_ provider: () -> NSView) {
        self.init()
        self.documentView = provider()
    }
    
    
    @discardableResult
    override func background(_ color: NativeColor) -> Self {
        if color.alphaComponent < 0.001 {
            self.drawsBackground = false
        }
        else {
            self.contentView.backgroundColor = color
        }
        
        return self
    }
    
    
    @discardableResult
    func verticallyScrollingContent() -> Self {
        if let documentView = self.documentView {
            documentView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                documentView.topAnchor.constraint(equalTo: contentView.topAnchor).priority(.required),
                documentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: documentView.trailingAnchor),
                
                documentView.heightAnchor.constraint(greaterThanOrEqualTo: contentView.heightAnchor),
            ])
        }
        return self
    }
}



extension NSLayoutConstraint {
    func priority(_ priority: Priority) -> Self {
        self.priority = priority
        return self
    }
}
