//
//  NSViewBuilder.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-04-05.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa



@_functionBuilder
public struct NSViewBuilder {
    
    @inlinable
    public static func buildBlock(_ content: NSView) -> NSView { content }
    
    @inlinable
    public static func buildBlock(_ content: NSView...) -> [NSView] { content }
    
    @inlinable
    public static func buildEither(first: NSView) -> NSView { first }
    
    @inlinable
    public static func buildEither(first: NSView...) -> [NSView] { first }
    
    @inlinable
    public static func buildEither(first: [NSView]) -> [NSView] { first }
    
    @inlinable
    public static func buildEither(second: NSView) -> NSView { second }
    
    @inlinable
    public static func buildEither(second: NSView...) -> [NSView] { second }
    
    @inlinable
    public static func buildEither(second: [NSView]) -> [NSView] { second }
    
    @inlinable
    public static func buildIf(_ content: NSView?) -> NSView { content ?? NSView() }
    
    @inlinable
    public static func buildOptional(_ content: NSView?) -> NSView { content ?? NSView() }
    
    @inlinable
    public static func buildElse(_ content: NSView?) -> NSView { content ?? NSView() }
}



public func ifLet<T>(
    _ t: T?,
    @NSViewBuilder _ whenHasValue: (T) -> NSView,
    @NSViewBuilder else whenNoValue: () -> NSView
) -> NSView {
    if let t = t {
        return whenHasValue(t)
    }
    else {
        return whenNoValue()
    }
}


public func ifLet<T>(
    _ t: T?,
    @NSViewBuilder _ whenHasValue: (T) -> [NSView],
    @NSViewBuilder else whenNoValue: () -> [NSView]
) -> [NSView] {
    if let t = t {
        return whenHasValue(t)
    }
    else {
        return whenNoValue()
    }
}
