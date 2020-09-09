//
//  SugaryView.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-27.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa
import CrossKitTypes
import RectangleTools



public protocol SugaryView {
    @discardableResult
    func background(_ color: NativeColor) -> NSView
    
    @discardableResult
    func padding(_ insets: NativeEdgeInsets) -> NSView
    
    @discardableResult
    func maxWidth(_ maxWidth: CGFloat) -> NSView
    
    @discardableResult
    func aspectRatio(_ aspectRatio: CGFloat) -> NSView
}



extension SugaryView {
    func padding() -> NSView {
        // TODO: More intelligent padding. Maybe derive from that Cocoa layout DSL?
        self.padding(NativeEdgeInsets(eachVertical: 4, eachHorizontal: 8))
    }
}



extension NSView: SugaryView {
    @discardableResult
    @objc
    public func background(_ color: NativeColor) -> NSView {
        self.wantsLayer = true
        self.layer?.backgroundColor = color.cgColor
        return self
    }
    
    
    @objc
    public func padding(_ insets: NativeEdgeInsets) -> NSView {
        NSView().fill(withNewSubview: self, insets: insets)
    }
    
    
    public func maxWidth(_ maxWidth: CGFloat) -> NSView {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth)
        ])
        return self
    }
    
    
    public func aspectRatio(_ aspectRatio: CGFloat) -> NSView {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: aspectRatio)
        ])
        return self
    }
}



public extension NSControl {
    @discardableResult
    func enabled(_ newEnabled: Bool) -> Self {
        self.isEnabled = newEnabled
        return self
    }
}
