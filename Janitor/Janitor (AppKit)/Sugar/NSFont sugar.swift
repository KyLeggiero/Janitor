//
//  NSFont sugar.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-15.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa
import CrossKitTypes



public extension NativeFont {
    static let caption = labelFont(ofSize: systemFontSize(for: .small))
}



public extension NativeFont {
    func weight(_ weight: Weight) -> NSFont {
        guard let familyName = self.familyName else {
            return self
        }
        
        return NSFontManager.shared.font(
            withFamily: familyName,
            traits: [],
            weight: Int(weight.rawValue * 15),
            size: self.pointSize)
        ?? self
    }
}
