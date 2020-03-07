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
    func fullWidthViews() -> Self {
        self.arrangedSubviews.forEach { view in
//            view.removeConstraints(view.constraints.filter { $0.isActive && $0.isHorizontal })
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                self.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
        return self
    }
}
