//
//  ViewProtocol + Rebuildable.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-27.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa



public extension ViewProtocol {
    func rebuild() {
        self.subviews.forEach { $0.removeFromSuperview() }
        
        self.fill(withNewSubview: self.body)
    }
}
