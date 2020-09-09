//
//  NSStackView sugar.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-06.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa



public extension NSStackView {
    convenience init(orientation: NSUserInterfaceLayoutOrientation, views: [NSView]) {
        self.init(views: views)
        self.orientation = orientation
    }
    
    
    @discardableResult
    func fullWidthViews(padding: NSEdgeInsets = .zero) -> Self {
        self.arrangedSubviews.forEach { view in
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding.leading),
                self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: padding.trailing)
            ])
        }
        return self
    }
}



@inline(__always)
public func VStack(_ views: [NSView]) -> NSStackView {
    NSStackView(orientation: .vertical, views: views)
}


@inline(__always)
public func VStack<Echoed>(@NSViewBuilder _ builder: () -> Echoed) -> Echoed
    where Echoed: NSView
{
    builder()
}


public func VStack(alignment: HorizontalAlignment = .center, @NSViewBuilder _ builder: () -> [NSView]) -> NSStackView {
    let stack = NSStackView(orientation: .vertical, views: builder())
    stack.alignment = alignment.layoutAttribute
    stack.setHuggingPriority(.required, for: .vertical)
    return stack
}


//@inline(__always)
//public func HStack(_ views: [NSView]) -> NSStackView {
//    NSStackView(orientation: .horizontal, views: views)
//}


@inline(__always)
public func HStack<Echoed>(alignment _: VerticalAlignment = .center, @NSViewBuilder _ builder: () -> Echoed) -> Echoed
    where Echoed: NSView
{
    builder()
}


public func HStack(alignment: VerticalAlignment = .center, @NSViewBuilder _ builder: () -> [NSView]) -> NSStackView {
    let stack = NSStackView(orientation: .horizontal, views: builder())
    stack.alignment = alignment.layoutAttribute
    stack.setHuggingPriority(.required, for: .horizontal)
    return stack
}



public enum HorizontalAlignment {
    case leading
    case center
    case trailing
    
    
    var layoutAttribute: NSLayoutConstraint.Attribute {
        switch self {
        case .leading: return .leading
        case .center: return .centerX
        case .trailing: return .trailing
        }
    }
}



public enum VerticalAlignment {
    case top
    case center
    case bottom
    
    
    var layoutAttribute: NSLayoutConstraint.Attribute {
        switch self {
        case .top: return .top
        case .center: return .centerY
        case .bottom: return .bottom
        }
    }
}
