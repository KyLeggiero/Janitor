//
//  async tools.swift
//  Janitor
//
//  Created by Ky Leggiero on 11/6/21.
//

import Foundation
import FunctionTools



func onMainActor(do action: @escaping @Sendable () -> Void) {
    Task {
        await MainActor.run(body: action)
    }
}
