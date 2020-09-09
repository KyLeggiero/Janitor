//
//  PathControlView.swift
//  Janitor
//
//  Created by Ben Leggiero on 2019-07-18.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import AppKit



struct PathControlView: NSViewRepresentable {
    
    typealias NSViewType = NSPathControl
    
    
    
    var url: URL
    
    
    func makeNSView(context: NSViewRepresentableContext<PathControlView>) -> NSViewType {
        let pathControl = NSPathControl()
        updateNSView(pathControl, context: context)
        return pathControl
    }
    
    
    func updateNSView(_ pathControl: NSViewType, context: NSViewRepresentableContext<PathControlView>) {
        pathControl.url = url
        pathControl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
}

#if DEBUG
struct PathControlView_Previews: PreviewProvider {
    static var previews: some View {
        PathControlView(url: URL(fileURLWithPath: "~/Desktop"))
    }
}
#endif
