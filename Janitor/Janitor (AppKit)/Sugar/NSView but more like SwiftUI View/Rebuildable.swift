//
//  Rebuildable.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-27.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Foundation



/// Something which can be rebuilt
public protocol Rebuildable {
    /// Rebuilds as necessary
    func rebuild()
}
