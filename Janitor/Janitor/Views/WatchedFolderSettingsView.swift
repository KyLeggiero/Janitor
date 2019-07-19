//
//  WatchedFolderSettingsView.swift
//  Janitor
//
//  Created by Ben Leggiero on 7/18/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import AppKit



struct WatchedFolderSettingsView: View {
    
    var url: URL
    var isEnabled: Binding<Bool>
    
    private var isEnabledCheckboxState: Binding<Checkbox.State>! = nil
    
    init(url: URL, isEnabled: Binding<Bool>) {
        self.url = url
        self.isEnabled = isEnabled
        
        self.isEnabledCheckboxState = Binding<Checkbox.State>(
            getValue: checkBoxStateBasedOnEnabled,
            setValue: updateEnabledBasedOnCheckboxState
        )
    }
    
    
    var body: some View {
        HStack {
            PathControlView(url: url)
                .frame(minWidth: 100, idealWidth: 200, minHeight: 16, idealHeight: 16, alignment: .leading)
            
            Checkbox(title: "Enabled", state: isEnabledCheckboxState, alignment: .checkboxTrailing)
        }
            .padding(.all)
            .border(Color.secondary, cornerRadius: 8)
            .background(Color.watchedFolderSettingsBackground)
    }
    
    
    private func checkBoxStateBasedOnEnabled() -> Checkbox.State {
        return .init(self.isEnabled.value)
    }
    
    
    private func updateEnabledBasedOnCheckboxState(_ newState: Checkbox.State) {
        switch newState {
        case .checked:
            self.isEnabled.value = true
            
        case .unchecked, .indeterminate:
            self.isEnabled.value = false
        }
    }
}

#if DEBUG
struct WatchedFolderSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        WatchedFolderSettingsView(url: URL(fileURLWithPath: "~/Desktop"), isEnabled: .constant(true))
    }
}
#endif
