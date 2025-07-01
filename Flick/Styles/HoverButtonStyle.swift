//
//  HoverButtonStyle.swift
//  Mini
//
//  Created by Austin Vesich on 10/17/24.
//

import SwiftUI

struct HoverButtonStyle: ButtonStyle {
    
    @State private var isHovering = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                if isHovering {
                    RoundedRectangle(cornerRadius: 8.0)
                        .fill(Material.ultraThin)
                }
            }
            .onHover { hovering in
                isHovering = hovering
            }
            .animation(.easeInOut(duration: VisualConfigConstants.fastAnimationDuration), value: isHovering)
    }
}

