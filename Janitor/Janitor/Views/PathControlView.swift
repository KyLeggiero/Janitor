//
//  PathControlView.swift
//  Janitor
//
//  Created by Ben Leggiero on 7/18/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI

struct PathControlView: NSViewRepresentable {
    
    typealias NSViewType = NSPathControl
    
    
    
    var url: URL
    
    
    func makeNSView(context: NSViewRepresentableContext<PathControlView>) -> NSViewType {
        let pathControl = NSPathControl()
        pathControl.url = url
        pathControl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return pathControl
    }
    
    
    func updateNSView(_ nsView: NSViewType, context: NSViewRepresentableContext<PathControlView>) {
        // TODO
    }
}

#if DEBUG
struct PathControlView_Previews: PreviewProvider {
    static var previews: some View {
        PathControlView(url: URL(fileURLWithPath: "~/Desktop"))
    }
}
#endif
