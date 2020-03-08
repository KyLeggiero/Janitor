//
//  NSLayoutConstraint sugar.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-06.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa
import RectangleTools



public extension NSLayoutConstraint {
    var isHorizontal: Bool {
        return type(of: firstAnchor) == NSLayoutXAxisAnchor.self
            && (secondAnchor.ifNotNull { type(of: $0) == NSLayoutXAxisAnchor.self } ?? false)
    }
}



public extension NSView {
    @discardableResult
    func addConstraints(asSoleParentOfAlreadyAddedSubview subview: NSView, insets: NSEdgeInsets = .zero) -> Self {
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: self.topAnchor, constant: insets.top),
            subview.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: insets.leading),
            self.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: insets.bottom),
            self.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: insets.trailing),
        ])
        return self
    }
    
    
    @discardableResult
    func fill(withNewSubview newSubview: NSView, insets: NSEdgeInsets = .zero) -> Self {
        addSubview(newSubview)
        addConstraints(asSoleParentOfAlreadyAddedSubview: newSubview, insets: insets)
        return self
    }
}
