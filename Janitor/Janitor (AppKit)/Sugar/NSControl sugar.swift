//
//  NSControl sugar.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-04-05.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa



public extension NSControl {
    @inlinable
    func controlSize(_ newControlSize: ControlSize) -> Self {
        self.controlSize = newControlSize
        return self
    }
}
