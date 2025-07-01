//
//  ShrinkOnPress.swift
//  Flick
//
//  Created by Austin Vesich on 6/11/25.
//

import SwiftUI
import Foundation

struct Pump: ViewModifier {
    
    @Binding public var pumping: Bool
    @State private var pumpScale: CGFloat = 1.0
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(pumpScale)
            .onChange(of: pumping) { _, shouldPump in
                guard shouldPump else { return }
                
                withAnimation(.easeOut(duration: 0.025)) {
                    pumpScale -= 0.15
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.025) {
                    withAnimation(.bouncy(duration: VisualConfigConstants.slowAnimationDuration+0.05, extraBounce: 0.1)) {
                        pumpScale = 1.0
                    }
                }
                
                pumping = false
            }
    }
}
