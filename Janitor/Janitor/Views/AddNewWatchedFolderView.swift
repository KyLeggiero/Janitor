//
//  AddNewWatchedFolderView.swift
//  Janitor
//
//  Created by Ben Leggiero on 7/19/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI

struct AddNewWatchedFolderView: View {
    
    @State private var isSheetShown = false
    
    var body: some View {
        HStack {
            Button(action: {
                    self.isSheetShown = true
                },
                label: {
                    Text("＋")
                }
            )
            Spacer()
        }
        
        .sheet(isPresented: $isSheetShown, content: { NewWatchedFolderSetupView() })
    }
}

#if DEBUG
struct AddNewWatchedFolderView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewWatchedFolderView()
    }
}
#endif
