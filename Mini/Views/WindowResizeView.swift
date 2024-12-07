//
//  WindowResizeView.swift
//  Mini
//
//  Created by Austin Vesich on 12/7/24.
//

import SwiftUI

struct WindowResizeView: View {
    
    @State var scrollSector: ScrollSector = .full
        
    var body: some View {
        RoundedRectangle(cornerRadius: 16.0)
            .fill(.black.opacity(0.001))
            .overlay {
                    PanTrackerView(scrollSector: $scrollSector)
            }
    }
}

#Preview {
    WindowResizeView()
}
