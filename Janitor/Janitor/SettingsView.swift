//
//  SettingsView.swift
//  Janitor
//
//  Created by Ky Leggiero on 2021-07-17.
//

import SwiftUI



struct SettingsView: View {
    var body: some View {
        Form {
            Toggle("Enabled", isOn: .constant(true))
                .toggleStyle(SwitchToggleStyle())
        }
        .padding()
    }
}
