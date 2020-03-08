//
//  NSEdgeInsets + RectangleTools.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-07.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa
import RectangleTools



extension NSEdgeInsets: FourSidedAbsolute {
    public init(top: CGFloat, right: CGFloat, bottom: CGFloat, left: CGFloat) {
        self.init(top: top, left: left, bottom: bottom, right: right)
    }
    
    
    public init(top: CGFloat, trailing: CGFloat, bottom: CGFloat, leading: CGFloat) {
        switch NSApp.userInterfaceLayoutDirection {
        case .leftToRight:
            self.init(top: top, right: trailing, bottom: bottom, left: leading)
            
        case .rightToLeft:
        self.init(top: top, right: leading, bottom: bottom, left: trailing)
            
        @unknown default:
            assertionFailure("Unknown user interface layout direction (will assume LTR): \(NSApp.userInterfaceLayoutDirection)")
            self.init(top: top, right: trailing, bottom: bottom, left: leading)
        }
    }
}



public extension NSEdgeInsets {
    var leading: CGFloat {
        switch NSApp.userInterfaceLayoutDirection {
        case .leftToRight: return left
        case .rightToLeft: return right
        @unknown default:
            assertionFailure("Unknown user interface layout direction (will assume LTR): \(NSApp.userInterfaceLayoutDirection)")
            return left
        }
    }
    
    
    var trailing: CGFloat {
        switch NSApp.userInterfaceLayoutDirection {
        case .leftToRight: return right
        case .rightToLeft: return left
        @unknown default:
            assertionFailure("Unknown user interface layout direction (will assume LTR): \(NSApp.userInterfaceLayoutDirection)")
            return right
        }
    }
}
