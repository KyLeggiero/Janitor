//
//  NSView but more like SwiftUI View.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-05.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa



public protocol View where Self: NSView {
    
    associatedtype Body: NSView
    
    var body: Body { get }
}



public extension View {
    
    init() {
        self.init(frame: .zero)
        
        self.addSubview(body)
    }
    
    init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported by this View")
    }
}
