//
//  NSButton sugar.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-11.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa
import FunctionTools



public extension NSButton {
    func bezelStyle(_ newStyle: BezelStyle) -> Self {
        self.bezelStyle = newStyle
        return self
    }
    
    
    func borderless(_ hideBorder: Bool = true) -> Self {
        self.isBordered = !hideBorder
        return self
    }
    
    
    func defaultButton() -> Self {
        self.keyEquivalent = "\n"
        return self
    }
}



public class Button: NSButton {
    
    private var targetShim: __NSButtonActionShim<Button>//! = nil
    
    init(_ title: String, action: @escaping Callback<Button>) {
        
        self.targetShim = __NSButtonActionShim(action: action)
        
        super.init(frame: .zero)
        self.bezelStyle = .rounded
        self.title = title
        self.target = targetShim
        self.action = #selector(targetShim.didPressButton)
    }
    
    
    convenience init(_ title: String, action: @escaping BlindCallback) {
        self.init(title) { _ in action() }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private class __NSButtonActionShim<Sender: Button>: NSObject {
        
        let action: Action
        
        init(action: @escaping Action) {
            self.action = action
        }
        
        
        @IBAction
        func didPressButton(sender: Button) {
            self.action(sender as! Sender)
        }
        
        
        
        typealias Action = (_ sender: Sender) -> Void
    }
}
