//
//  Spacer.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-27.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa



public func Spacer() -> some NSView {
    NSView()
        .huggingPriority(.lowest, for: .horizontal)
        .huggingPriority(.lowest, for: .vertical)
        .compressionResistancePriority(.lowest, for: .horizontal)
        .compressionResistancePriority(.lowest, for: .vertical)
}
