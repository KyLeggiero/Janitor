//
//  Checkbox.swift
//  Janitor
//
//  Created by Ben Leggiero on 7/18/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI



struct Checkbox: NSViewRepresentable {
    
    typealias NSViewType = NSButton
    
    
    
    var title: String
    var state: Binding<State>
    var alignment: Alignment
    private var shim: Shim!
    
    
    init(title: String, state: Binding<State>, alignment: Alignment = .checkboxLeading) {
        self.title = title
        self.state = state
        self.alignment = alignment
        self.shim = Shim(self)
    }
    
    
    func makeNSView(context: NSViewRepresentableContext<Checkbox>) -> NSViewType {
        let checkbox = NSViewType(checkboxWithTitle: title, target: shim, action: #selector(Shim.didPress))
        checkbox.imagePosition = .init(alignment)
        checkbox.alignment = .init(alignment)
        checkbox.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        checkbox.setContentHuggingPriority(.required, for: .horizontal)
        return checkbox
    }
    
    
    func updateNSView(_ nsView: NSViewType, context: NSViewRepresentableContext<Checkbox>) {
        // TODO
    }
    
    
    private func shimDidRegisterPress(newState: NSControl.StateValue) {
        self.state.value = State(newState)
    }
    
    
    
    enum State {
        case checked
        case unchecked
        case indeterminate
        
        static let intermediate = State.indeterminate
        
        
        init(_ nsControlState: NSControl.StateValue) {
            switch nsControlState {
            case .on:
                self = .checked
                
            case .off:
                self = .unchecked
                
            case .mixed:
                self = .indeterminate
                
            default:
                self = .unchecked
            }
        }
        
        
        init(_ isChecked: Bool) {
            self = isChecked ? .checked : .unchecked
        }
    }
    
    
    enum Alignment {
        case checkboxLeading
        case checkboxTrailing
    }
    
    
    
    typealias OnStateChange = (_ oldState: State, _ newState: State) -> Void
    
    
    
    private class Shim {
        
        let parent: Checkbox
        
        init(_ parent: Checkbox) {
            self.parent = parent
        }
        
        @objc
        func didPress(sender: NSButton) {
            parent.shimDidRegisterPress(newState: sender.state)
        }
    }
}



#if DEBUG
struct Checkbox_Previews: PreviewProvider {
    static var previews: some View {
        Checkbox(title: "Example", state: .constant(.checked))
    }
}
#endif



extension NSControl.ImagePosition {
    init(_ checkboxAlignment: Checkbox.Alignment) {
        switch checkboxAlignment {
        case .checkboxLeading:
            self = .imageLeading
            
        case .checkboxTrailing:
            self = .imageTrailing
        }
    }
}



extension NSTextAlignment {
    init(_ checkboxAlignment: Checkbox.Alignment) {
        switch checkboxAlignment {
        case .checkboxLeading:
            self = .natural
            
        case .checkboxTrailing:
            switch NSApp.userInterfaceLayoutDirection {
            case .leftToRight:
                self = .right
                
            case .rightToLeft:
                self = .left
                
            @unknown default:
                self = .right
            }
        }
    }
}
