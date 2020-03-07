//
//  NSLayoutConstraint sugar.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-06.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa



public extension NSLayoutConstraint {
    var isHorizontal: Bool {
        return type(of: firstAnchor) == NSLayoutXAxisAnchor.self
            && (secondAnchor.ifNotNull { type(of: $0) == NSLayoutXAxisAnchor.self } ?? false)
    }
}
