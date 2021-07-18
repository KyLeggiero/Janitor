//
//  OpenPanel.swift
//  Janitor
//
//  Created by Ben Leggiero on 7/25/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import AppKit



struct OpenPanel: NSViewRepresentable {
    
    typealias NSViewType = NSView
    
    
    
    let didSelectFiles: DidSelectFiles
    let didCancel: DidCancel
    
    private let openPanel = SwiftUiOpenPanelShim()
    private let openPanelDelegate = OpenPanelDelegate()
    
    
    func makeNSView(context: NSViewRepresentableContext<OpenPanel>) -> NSViewType {
        openPanel.delegate = openPanelDelegate
        openPanel.didSelectFiles = didSelectFiles
        openPanel.didCancel = didCancel
        return openPanel.contentView!
    }
    
    
    func updateNSView(_ nsView: NSViewType, context: NSViewRepresentableContext<OpenPanel>) {
        // TODO
    }
    
    
    
    typealias DidSelectFiles = ([URL]) -> Void
    typealias DidCancel = () -> Void
}



@objc
private class SwiftUiOpenPanelShim: NSOpenPanel {
    
    var didSelectFiles: OpenPanel.DidSelectFiles = { _ in}
    var didCancel: OpenPanel.DidCancel = { }
    
    
    @objc
    @IBAction
    override func ok(_ sender: Any?) {
        didSelectFiles(self.urls)
    }
    
    
    @objc
    @IBAction
    override func cancel(_ sender: Any?) {
        didCancel()
    }
}



private class OpenPanelDelegate: NSObject, NSOpenSavePanelDelegate {
    
}



#if DEBUG
struct OpenPanel_Previews: PreviewProvider {
    static var previews: some View {
        OpenPanel(didSelectFiles: { _ in }, didCancel: {})
    }
}
#endif
