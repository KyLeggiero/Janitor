//
//  SelectFileControl.swift
//  Janitor
//
//  Created by Ben Leggiero on 7/25/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Cocoa
import JanitorKit
import SafePointer



class SelectFileControl: View {
    
    var selectedFile: SelectedFile
    
    private var selectedFileObserverIdentifier = ObserverIdentifier()
    
    
    init(selectedFile: SelectedFile) {
        self.selectedFile = selectedFile
        
        super.init()
        
        self.selectedFileObserverIdentifier = self.selectedFile.addObserver { [weak self] _, _ in
            self?.rebuild()
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        self.selectedFile.removeObserver(withId: selectedFileObserverIdentifier)
    }
    
    
    var body: some NSView {
        HStack(alignment: .center) {
            Button("Select", action: self.didPressSelectFileButton)
                .controlSize(.small)
            
            ifLet(self.selectedFile.wrappedValue, { selectedFile in
                NSPathControl(selectedFile)
            },
            else: {
                HStack {
                    Text(labelWithString: "📂")
                    Spacer()
                }
            })
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
                self.selectedFile.pointee = panel.url
                
            default:
                self.selectedFile.pointee = nil
            }
        }
    }
    
    
    
    typealias OnSelectionChanged = (URL?) -> Void
    typealias SelectedFile = ObservableSafeMutablePointer<URL?>
}
