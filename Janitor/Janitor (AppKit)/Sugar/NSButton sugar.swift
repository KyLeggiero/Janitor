//
//  NSButton sugar.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-11.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa



public extension NSButton {
    func bezelStyle(_ newStyle: BezelStyle) -> Self {
        self.bezelStyle = newStyle
        return self
    }
    
    
    func borderless(_ hideBorder: Bool = true) -> Self {
        self.isBordered = !hideBorder
        return self
    }
}
