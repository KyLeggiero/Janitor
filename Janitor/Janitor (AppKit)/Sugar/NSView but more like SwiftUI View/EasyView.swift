//
//  EasyView.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-27.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa



public class EasyView: NSView {
    
    public var popoverCache = HasPopover.PopoverCache(to: .init())
    
    
    public init() {
        super.init(frame: .zero)
        
        (self as? Rebuildable)?.rebuild()
    }
    
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported by this View")
    }
}
