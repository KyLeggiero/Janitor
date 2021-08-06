//
//  SettingsView.swift
//  Janitor
//
//  Created by Ky Leggiero on 2021-07-17.
//

import SwiftUI

import Introspection
import JanitorKit



struct SettingsView: View {
    
    @EnvironmentObject
    public var janitorialEngine: JanitorialEngine
    
    
    @State
    private var enableToggleValue = false
    
    
    var body: some View {
        Form {
            Toggle("Enable \(Introspection.appName)", isOn: .init(
                get: { janitorialEngine.dryRun },
                set: { newValue in Task.detached {await janitorialEngine.setDryRun{newValue}} }))
                .toggleStyle(SwitchToggleStyle())
        }
        .padding()
        .frame(minWidth: 360, alignment: .topLeading)
    }
}
