//
//  SelectFileControl.swift
//  Janitor
//
//  Created by Ben Leggiero on 7/25/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI

struct SelectFileControl: View {
    
    @Binding
    var selectedFile: URL?
    
    var body: some View {
        HStack {
            Button("Select", action: self.didPressSelectFileButton)
                .controlSize(.small)
            #if swift(>=5.1.1)
            if let selectedFile = self.selectedFile.value {
                PathControlView(url: selectedFile)
            }
            else {
                Text("📂")
                Spacer()
            }
            #else
            if selectedFile != nil {
                PathControlView(url: selectedFile!) // 🤮 I hope they fix this before SwiftUI goes public
            }
            else {
                Text("📂")
                Spacer()
            }
            #endif
        }
    }
        
        
        func didPressSelectFileButton() {
            let panel = NSOpenPanel()
            panel.canChooseDirectories = true
            panel.canChooseFiles = false
            panel.directoryURL = URL.User.home
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let result = panel.runModal()
                switch result {
                case .OK:
                    self.selectedFile = panel.url
                    
                default:
                    self.selectedFile = nil
                }
            }
        }
    
    
    
    typealias OnSelectionChanged = (URL?) -> Void
}

#if DEBUG
struct SelectFileControl_Previews: PreviewProvider {
    static var previews: some View {
        SelectFileControl(selectedFile: .constant(nil))
    }
}
#endif
