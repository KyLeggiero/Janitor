//
//  NSBox sugar.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-07.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa



public extension NSBox {
    
    @inlinable
    convenience init(padding: NSEdgeInsets = .zero, content: () -> NSView) {
        self.init(frame: .zero)
        
        self.contentView!.fill(withNewSubview: content(), insets: padding)
    }
    
    
    @inlinable
    convenience init(title: String?, padding: NSEdgeInsets = .zero, content: () -> NSView) {
        self.init(padding: padding, content: content)
        self.title(title)
    }
    
    
    @discardableResult
    @inlinable
    func title(_ text: String?) -> Self {
        if let text = text {
            self.title = text
        }
        else {
            self.titlePosition = .noTitle
        }
        return self
    }
}
