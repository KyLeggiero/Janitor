//
//  NSView but more like SwiftUI View.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-05.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa
import CrossKitTypes
import SafePointer
import DrawingTools
import SafePointer
import RectangleTools



public typealias View = EasyView & ViewProtocol



/// Something which can be rebuilt
public protocol Rebuildable {
    /// Rebuilds as necessary
    func rebuild()
}



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



public protocol ViewProtocol: NSView, Rebuildable, HasPopover {
    
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
        
        self.fill(withNewSubview: self.body)
    }
    
    
    func updateDisplay(ofPopoverWithId id: AnyHashable) {
        
        guard let cachedPopover = self.popoverCache.pointee[id] else {
//            // No popover with this ID? Probably because we didn't create it before because `isPresented` was false. Rebuild so the popovers can be created as intended.
//            rebuild()
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



public protocol SugaryView {
    @discardableResult
    func background(_ color: NativeColor) -> NSView
    
    @discardableResult
    func padding(_ insets: NativeEdgeInsets) -> NSView
    
    @discardableResult
    func maxWidth(_ maxWidth: CGFloat) -> NSView
    
    @discardableResult
    func aspectRatio(_ aspectRatio: CGFloat) -> NSView
}



extension SugaryView {
    func padding() -> NSView {
        // TODO: More intelligent padding. Maybe derive from that Cocoa layout DSL?
        self.padding(NativeEdgeInsets(eachVertical: 4, eachHorizontal: 8))
    }
}



extension NSView: SugaryView {
    @discardableResult
    @objc
    public func background(_ color: NativeColor) -> NSView {
        self.wantsLayer = true
        self.layer?.backgroundColor = color.cgColor
        return self
    }
    
    
    @objc
    public func padding(_ insets: NativeEdgeInsets) -> NSView {
        NSView().fill(withNewSubview: self, insets: insets)
    }
    
    
    public func maxWidth(_ maxWidth: CGFloat) -> NSView {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth)
        ])
        return self
    }
    
    
    public func aspectRatio(_ aspectRatio: CGFloat) -> NSView {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: aspectRatio)
        ])
        return self
    }
}



extension NSControl {
    @discardableResult
    public func enabled(_ newEnabled: Bool) -> Self {
        self.isEnabled = newEnabled
        return self
    }
}



public func Spacer() -> some NSView {
    let spacer = NSView()
        .huggingPriority(.lowest, for: .horizontal)
        .huggingPriority(.lowest, for: .vertical)
        .compressionResistancePriority(.lowest, for: .horizontal)
        .compressionResistancePriority(.lowest, for: .vertical)
    return spacer
}
