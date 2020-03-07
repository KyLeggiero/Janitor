//
//  NSView but more like SwiftUI View.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-05.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa
import CrossKitTypes



public typealias View = EasyView & ViewProtocol



public protocol Rebuildable {
    func rebuild()
}



public protocol ViewProtocol: NSView, Rebuildable {
    
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
    
    
    func rebuild() {
        self.subviews.forEach { $0.removeFromSuperview() }
        
        let soleSubview = self.body
        self.addSubview(soleSubview)
        soleSubview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            soleSubview.topAnchor.constraint(equalTo: topAnchor),
            soleSubview.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomAnchor.constraint(equalTo: soleSubview.bottomAnchor),
            trailingAnchor.constraint(equalTo: soleSubview.trailingAnchor)
        ])
    }
}



public class EasyView: NSView {
    
    public init() {
        super.init(frame: .zero)
        
        (self as? Rebuildable)?.rebuild()
    }
    
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported by this View")
    }
}



public protocol SugaryView {
    @discardableResult
    func background(_ color: NativeColor) -> Self
}



extension NSView: SugaryView {
    @discardableResult
    @objc
    public func background(_ color: NativeColor) -> Self {
        self.wantsLayer = true
        self.layer?.backgroundColor = color.cgColor
        return self
    }
}
