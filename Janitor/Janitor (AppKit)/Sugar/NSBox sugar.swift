//
//  NSBox sugar.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-07.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Cocoa



public extension NSBox {
    func title<Text: StringProtocol>(_ text: Text) -> Self {
        self.title = String(text)
        return self
    }
}
