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
    @inlinable
    convenience init(_ provider: () -> NSView) {
        self.init()
        self.documentView = provider()
    }
    
    
    @discardableResult
//    @inlinable // causes a segfault in the Swift compiler
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
    @inlinable
    func verticallyScrollingContent(padding: NSEdgeInsets = .zero) -> Self {
        if let documentView = self.documentView {
            documentView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                documentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding.top).priority(.required),
                contentView.leadingAnchor.constraint(equalTo: documentView.leadingAnchor, constant: padding.leading),
                contentView.trailingAnchor.constraint(equalTo: documentView.trailingAnchor, constant: padding.trailing),
                
                documentView.heightAnchor.constraint(greaterThanOrEqualTo: contentView.heightAnchor, constant: -padding.bottom),
            ])
        }
        return self
    }
}



public extension NSLayoutConstraint {
    @inlinable
    func priority(_ priority: Priority) -> Self {
        self.priority = priority
        return self
    }
}
