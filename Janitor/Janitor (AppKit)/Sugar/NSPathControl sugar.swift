//
//  NSPathControl sugar.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-07.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa



public extension NSPathControl {
    convenience init(_ url: URL) {
        self.init(frame: .zero)
        self.url = url
    }
}
