//
//  ViewProtocol + HasPopover.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-27.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa



public extension ViewProtocol {
    
    func updateDisplay(ofPopoverWithId id: AnyHashable) {
        
        guard let cachedPopover = self.popoverCache.pointee[id] else {
            return
        }
        
        
        switch cachedPopover.presentation {
        case (wasPresented: false, shouldBePresented: true, isPresented: _):
            createAndDisplayPopover(for: cachedPopover)
            
        case (wasPresented: true, shouldBePresented: false, isPresented: _):
            hideAndDestroyPopover(for: cachedPopover)
            
        case (wasPresented: true, shouldBePresented: true, isPresented: _),
             (wasPresented: false, shouldBePresented: false, isPresented: _):
            // Do nothing?
            break
        }
    }
    
    
    private func createAndDisplayPopover(for cachedPopover: CachedPopover) {
        let popover = cachedPopover.shownPopover?.popover ?? NSPopover()
        popover.behavior = .transient
        
        let observer = popover.observe(\.isShown) { [weak self] (popover, change) in
            guard var cachedPopover = self?.popoverCache.pointee[cachedPopover.id] else {
                return
            }
            
            let newValue = change.newValue ?? false
            
            cachedPopover.presentation.wasPresented = cachedPopover.shouldBePresented
            cachedPopover.presentation.shouldBePresented = newValue
            cachedPopover.presentation.isPresented.pointee = newValue
            
            self?.popoverCache.pointee[cachedPopover.id] = cachedPopover
        }
        
        let controller = NSViewController()
        controller.view = cachedPopover.content
        popover.contentViewController = controller
        popover.show(relativeTo: cachedPopover.targetView.pointee.bounds,
                     of: cachedPopover.targetView.pointee,
                     preferredEdge: .init(cachedPopover.preferredEdge))
        
        popoverCache.pointee[cachedPopover.id] = CachedPopover(
            id: cachedPopover.id,
            presentation: (wasPresented: cachedPopover.shouldBePresented,
                           shouldBePresented: true,
                           isPresented: cachedPopover.presentation.isPresented),
            targetView: cachedPopover.targetView,
            preferredEdge: cachedPopover.preferredEdge,
            content: cachedPopover.content,
            shownPopover: (popover: popover, observers: [observer] + (cachedPopover.shownPopover?.observers ?? []))
        )
    }
    
    
    private func hideAndDestroyPopover(for cachedPopover: CachedPopover) {
        cachedPopover.shownPopover?.popover.close()
        let timerId = UUID()
        popoverDismissWaitTimers[timerId] = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            self?.popoverCache.pointee.removeValue(forKey: cachedPopover.id)
        }
    }
}



private var popoverDismissWaitTimers = [UUID : Timer]()
