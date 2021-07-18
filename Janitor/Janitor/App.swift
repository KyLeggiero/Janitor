//
//  App.swift
//  Janitor
//
//  Created by Ky Leggiero on 2021-07-17.
//

import SwiftUI

@main
struct App: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        Settings {
            SettingsView()
        }
    }
}
