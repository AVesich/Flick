//
//  ShrinkOnPress.swift
//  Flick
//
//  Created by Austin Vesich on 6/11/25.
//

import SwiftUI

struct ShrinkOnPress: ViewModifier {
    
    @State public var pressed = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(pressed ? 1.0 - VisualConfigConstants.selectionPumpStrength : 1.0)
            .animation(.bouncy(duration: VisualConfigConstants.slowAnimationDuration, extraBounce: 0.1), value: pressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        pressed = true
                    }
                    .onEnded { _ in
                        pressed = false
                    }
            )
    }
}
