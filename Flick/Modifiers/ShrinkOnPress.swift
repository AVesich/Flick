//
//  ShrinkOnPress.swift
//  Flick
//
//  Created by Austin Vesich on 6/11/25.
//

import SwiftUI

struct ShrinkOnPress: ViewModifier {
    
    public let mouseReactivityEnabled: Bool
    @Binding public var isPressed: Bool
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed && mouseReactivityEnabled ? 1.0 - VisualConfigConstants.selectionPumpStrength : 1.0)
            .animation(.bouncy(duration: VisualConfigConstants.slowAnimationDuration, extraBounce: 0.1), value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        isPressed = true
                    }
                    .onEnded { _ in
                        isPressed = false
                    }
            )
    }
}
