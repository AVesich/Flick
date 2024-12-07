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
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 16.0)
                .fill(.black.opacity(0.001))
                .overlay {
                    ZStack {
                        VStack(alignment: .center) {
                            Text("Swipe with 2 fingers to arrange the window.")
                        }
                        RoundedRectangle(cornerRadius: 16.0)
                            .stroke(.white, lineWidth: 4.0)
                            .padding(2.0)
                            .frame(width: <#T##CGFloat?#>, height: <#T##CGFloat?#>)
                        PanTrackerView(scrollSector: $scrollSector)
                    }
                }
        }
    }
}

#Preview {
    WindowResizeView()
}
