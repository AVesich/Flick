//
//  BackgroundPulse.swift
//  Flick
//
//  Created by Austin Vesich on 6/11/25.
//

import SwiftUI

struct BackgroundPulse: ViewModifier {
    public var enabled: Bool
    public var color: Color
    @State private var shadowColor: Color = .clear
    @State private var shadowRadius: CGFloat = 0.0
        
    func body(content: Content) -> some View {
        ZStack() {
            content
                .background {
                    RoundedRectangle(cornerRadius: VisualConfigConstants.largeCornerRadius)
                        .stroke(shadowColor, lineWidth: shadowRadius)
                        .blur(radius: shadowRadius)
                        .onChange(of: enabled) {
                            guard enabled else { return }
                            shadowRadius = 0.0
                            shadowColor = .red
                            
                            withAnimation(.easeOut(duration: VisualConfigConstants.slowAnimationDuration*2)) {
                                shadowRadius = 64.0
                                shadowColor = .red.opacity(0.0)
                            }
                        }
                }
        }
    }
}

extension View {
    func backgroundPulse(enabled isEnabled: Bool, color: Color) -> some View {
        modifier(BackgroundPulse(enabled: isEnabled, color: color))
    }
}
