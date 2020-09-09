//
//  TODO returning anything.swift
//  Janitor
//
//  Created by Ben Leggiero on 2020-03-05.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//



public func TODO<T>(_ message: String = "Not yet implemented") -> T {
    fatalError("TODO: \(message)")
}
