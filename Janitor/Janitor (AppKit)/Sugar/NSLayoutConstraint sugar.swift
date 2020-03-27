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
    func addConstraints(asSoleParentOfAlreadyAddedSubview subview: NSView, insets: NativeEdgeInsets = .zero) -> Self {
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: self.topAnchor, constant: insets.top),
            subview.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: insets.leading),
            self.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: insets.bottom),
            self.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: insets.trailing),
            
            subview.heightAnchor.constraint(greaterThanOrEqualToConstant: subview.fittingSize.height),
            subview.widthAnchor.constraint(greaterThanOrEqualToConstant: subview.fittingSize.width),
        ])
        return self
    }
    
    
    @discardableResult
    func fill(withNewSubview newSubview: NSView, insets: NativeEdgeInsets = .zero) -> Self {
        addSubview(newSubview)
        addConstraints(asSoleParentOfAlreadyAddedSubview: newSubview, insets: insets)
        return self
    }
}



public extension NSView {
    
    @discardableResult
    func huggingPriority(_ huggingPriority: NSLayoutConstraint.Priority, for orientation: NSLayoutConstraint.Orientation) -> Self {
        self.setContentHuggingPriority(huggingPriority, for: orientation)
        return self
    }
    
    
    @discardableResult
    func compressionResistancePriority(_ compressionResistancePriority: NSLayoutConstraint.Priority, for orientation: NSLayoutConstraint.Orientation) -> Self {
        self.setContentCompressionResistancePriority(compressionResistancePriority, for: orientation)
        return self
    }
}



public extension NSLayoutConstraint.Priority {
    static let lowest = NSLayoutConstraint.Priority.init(.leastNonzeroMagnitude)
}
