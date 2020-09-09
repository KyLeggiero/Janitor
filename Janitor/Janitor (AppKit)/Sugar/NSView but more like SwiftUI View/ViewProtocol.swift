//
//  ViewProtocol.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-27.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa



public protocol ViewProtocol: NSView, Rebuildable, HasPopover, HasSheet {
    
    associatedtype Body: NSView
    
    var body: Body { get }
}



public extension ViewProtocol {
    
    init() {
        self.init(frame: .zero)
        
        self.rebuild()
    }
    
    
    init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported by this View")
    }
}
