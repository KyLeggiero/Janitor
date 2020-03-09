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


public func VStack<Echoed>(@NSViewBuilder _ builder: () -> Echoed) -> Echoed {
    builder()
//    NSStackView(orientation: .vertical, views: [builder()])
}


public func VStack(alignment: HorizontalAlignment = .center, @NSViewBuilder _ builder: () -> [NSView]) -> NSStackView {
    let stack = NSStackView(orientation: .vertical, views: builder())
    stack.alignment = alignment.layoutAttribute
    stack.setHuggingPriority(.required, for: .vertical)
    return stack
}


@inline(__always)
public func HStack(_ views: [NSView]) -> NSStackView {
    NSStackView(orientation: .horizontal, views: views)
}



@_functionBuilder
public struct NSViewBuilder {
    public static func buildBlock(_ content: NSView) -> NSView {
        return content
    }
    
    
    public static func buildBlock(_ content: NSView...) -> [NSView] {
        return content
    }
}



public enum HorizontalAlignment {
    case leading
    case center
    case trailing
    
    
    var layoutAttribute: NSLayoutConstraint.Attribute {
        switch self {
        case .leading: return .leading
        case .center: return .centerX
        case .trailing: return .centerY
        }
    }
}
