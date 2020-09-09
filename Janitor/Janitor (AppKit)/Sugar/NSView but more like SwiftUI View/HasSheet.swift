//
//  HasSheet.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-27.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa
import SafePointer
import LazyContainers



public protocol HasSheet {
    
}



public extension ViewProtocol {
    func sheet<Item>(
        item itemProvider: ObservableSafeMutablePointer<Item?>,
        content: @escaping (SafeMutablePointer<Item?>) -> NSView) -> Self
    {
        var isSafeToUpdate = true
        let window = Lazy(initializer: NSWindow.init)
        
        
        func present(_ item: Item) {
            let controller = NSViewController()
            
            
            let itemPointer = SafeMutablePointer<Item?>(to: item) { old, new in
                if let new = new {
                    isSafeToUpdate = false
                    itemProvider.pointee = new
                    isSafeToUpdate = true
                    
                    if !window.isVisible {
                        present(new)
                    }
                    else {
                        // window already presented; presumably its content is up-to-date, so there's nothing to do?
                    }
                }
                else {
                    endSheet()
                }
            }
            
            controller.view = content(itemPointer)
            
            
            window.contentViewController = controller
            self.window?.beginSheet(window.wrappedValue, completionHandler: nil)
        }
        
        
        func endSheet() {
            window.wrappedValue.close()
        }
        
        
        itemProvider.addObserver { (_, item) in
            if let item = item,
                isSafeToUpdate
            {
                present(item)
            }
            else {
                endSheet()
            }
        }
        
        return self
    }
}
