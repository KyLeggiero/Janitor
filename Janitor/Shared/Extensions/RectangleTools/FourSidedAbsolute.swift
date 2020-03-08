//
//  FourSidedAbsolute.swift
//  Janitor (AppKit)
//
//  Created by Ben Leggiero on 2020-03-07.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import RectangleTools



public protocol FourSidedAbsolute {
    
    associatedtype Length
    
    var top: Length { get }
    var right: Length { get }
    var bottom: Length { get }
    var left: Length { get }
    
    
    init(top: Length, right: Length, bottom: Length, left: Length)
}



public extension FourSidedAbsolute {
    
    @inline(__always)
    init(top: Length, eachHorizontal: Length, bottom: Length) {
        self.init(
            top: top,
            right: eachHorizontal,
            bottom: bottom,
            left: eachHorizontal
        )
    }
    
    
    @inline(__always)
    init(eachVertical: Length, eachHorizontal: Length) {
        self.init(
            top: eachVertical,
            eachHorizontal: eachHorizontal,
            bottom: eachVertical
        )
    }
    
    
    @inline(__always)
    init(each: Length) {
        self.init(
            eachVertical: each,
            eachHorizontal: each
        )
    }
}



public extension FourSidedAbsolute where Length: ExpressibleByIntegerLiteral {
    static var zero: Self { Self.init(each: 0) }
}
