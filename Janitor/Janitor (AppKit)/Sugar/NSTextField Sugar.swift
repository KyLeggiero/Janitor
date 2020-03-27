//
//  NSTextField Sugar.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-15.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa
import AttributedStringBuilder



public typealias Text = NSTextField



public extension NSTextField {
    @inline(__always)
    convenience init(_ labelAttributedString: NSAttributedString) {
        self.init(labelWithAttributedString: labelAttributedString)
    }
    
    
    @inlinable
    convenience init(@AttributedStringBuilder _ content: () -> NSAttributedString) {
        self.init(NSAttributedString(content))
    }
}



public extension NSTextField {
    func allowTextWrapping(_ allowTextWrapping: Bool) -> Self {
        self.cell?.usesSingleLineMode = !allowTextWrapping
        self.cell?.wraps = allowTextWrapping
        self.usesSingleLineMode = !allowTextWrapping
        self.lineBreakMode = allowTextWrapping ? .byWordWrapping : .byTruncatingMiddle
        return self
    }
}
