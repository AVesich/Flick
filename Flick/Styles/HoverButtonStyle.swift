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
            .padding(.horizontal, 16.0)
            .background {
                if isHovering {
                    RoundedRectangle(cornerRadius: 8.0)
                        .fill(.white.opacity(0.1))
                }
            }
            .onHover { hovering in
                isHovering = hovering
            }
            .animation(.easeInOut(duration: 0.1), value: isHovering)
    }
}

