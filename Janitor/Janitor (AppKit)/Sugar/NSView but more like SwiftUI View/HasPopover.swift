//
//  HasPopover.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-27.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa
import SafePointer
import DrawingTools
import CrossKitTypes



/// Something which has one or more popovers
public protocol HasPopover {
    
    var popoverCache: PopoverCache { get set }
    
    func updateDisplay(ofPopoverWithId: AnyHashable)
    
    
    
    typealias PopoverCache = MutableSafePointer<[AnyHashable : CachedPopover]>
}



public struct CachedPopover {
    let id: AnyHashable
    var presentation: (wasPresented: Bool, shouldBePresented: Bool, isPresented: ObservableMutableSafePointer<Bool>)
    var targetView: SafePointer<NSView>
    var preferredEdge: PopoverTargetEdge
    var content: NSView
    var shownPopover: (popover: NSPopover, observers: [NSKeyValueObservation])?
}



public enum PopoverTargetEdge {
    case top
    case leading
    case bottom
    case trailing
}



public extension NSRectEdge {
    init(_ popoverTargetEdge: PopoverTargetEdge) {
        switch (
            edge: popoverTargetEdge,
            isFlipped: NativeImage.defaultFlipped,
            uiDirection: NSApp.userInterfaceLayoutDirection
        ) {
        case (edge: .top, isFlipped: true, uiDirection: _),
             (edge: .bottom, isFlipped: false, uiDirection: _):
            self = .maxY
            
        case (edge: .top, isFlipped: false, uiDirection: _),
             (edge: .bottom, isFlipped: true, uiDirection: _):
            self = .minY
            
        case (edge: .leading, isFlipped: _, uiDirection: .leftToRight),
             (edge: .trailing, isFlipped: _, uiDirection: .rightToLeft):
            self = .minX
            
        case (edge: .leading, isFlipped: _, uiDirection: .rightToLeft),
             (edge: .trailing, isFlipped: _, uiDirection: .leftToRight):
            self = .maxX
            
        @unknown default:
            let message = "Defaulting to maxY due to the following unknown combination: (edge: \(popoverTargetEdge), isFlipped: \(NativeImage.defaultFlipped), uiDirection: \(NSApp.userInterfaceLayoutDirection.rawValue))"
            assertionFailure(message)
            print(message)
            NSLog("%s", message)
            self = .maxY
        }
    }
}



public extension CachedPopover {
    var wasPresented: Bool {
        get { presentation.wasPresented }
        set { presentation.wasPresented = newValue }
    }
    
    
    var shouldBePresented: Bool {
        get { presentation.shouldBePresented }
        set { presentation.shouldBePresented = newValue }
    }
}



public extension NSView {
    func popover<ParentView>(withId id: AnyHashable,
                             parent: ParentView,
                             isPresented: ObservableMutableSafePointer<Bool>,
                             arrowEdge: PopoverTargetEdge = .top,
                             content: @escaping () -> NSView
    ) -> Self
        where
            ParentView: HasPopover,
            ParentView: NSView
    {
        func createAndCachePopover(wasPresented: Bool, shouldBePresented: Bool) {
            
            parent.popoverCache.pointee[id] = CachedPopover(
                id: id,
                presentation: (wasPresented: wasPresented,
                               shouldBePresented: shouldBePresented,
                               isPresented: isPresented),
                targetView: SafePointer(to: self),
                preferredEdge: arrowEdge,
                content: content()
            )
        }
        
        
        isPresented.addObserver { _, newIsPresented in
            if newIsPresented {
                if let popover = parent.popoverCache.pointee[id] {
                    if popover.wasPresented {
                        parent.popoverCache.pointee[id]?.presentation = (wasPresented: true,
                                                                         shouldBePresented: true,
                                                                         isPresented: isPresented)
                        return
                    }
                    else {
                        createAndCachePopover(wasPresented: false, shouldBePresented: true)
                    }
                }
                else { // no cached popover
                    createAndCachePopover(wasPresented: false, shouldBePresented: true)
                }
            }
            else { // Do not present
                if nil != parent.popoverCache.pointee[id] {
                    parent.popoverCache.pointee[id]?.shouldBePresented = false
                }
                else { // no cached popover
                    // Nothing to do?
                    return
                }
            }
        }

        parent.updateDisplay(ofPopoverWithId: id)
        return self
    }
}
