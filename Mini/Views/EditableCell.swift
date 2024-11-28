//
//  EditableCell.swift
//  Mini
//
//  Created by Austin Vesich on 11/25/24.
//

import SwiftUI

struct EditableCell<Content: View>: View {
    
    public var leftEdit: CGFloat = 0.0
    public var rightEdit: CGFloat = 0.0
    public var selected: Bool
    
    public var leftColor: Color = .red
    public var leftIcon: Image = Image(systemName: "xmark")
    public var rightColor: Color = .blue
    public var rightIcon: Image = Image(systemName: "pencil")
    
    public var content: () -> Content
    
    private var currentEdit: CGFloat {
        max(rightEdit, leftEdit)
    }
    @State private var dashPhase: CGFloat = 80.0
    
    var body: some View {
        content()
            .scaleEffect(x: 1+rightEdit/65.0, y: 1-rightEdit/20.0, anchor: .leading)
            .scaleEffect(x: 1+leftEdit/65.0, y: 1-leftEdit/20.0, anchor: .trailing)
            .animation(.bouncy(duration: 0.2, extraBounce: 0.23), value: currentEdit)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .overlay {
                ZStack {
                    // Drag to the right
                    RoundedRectangle(cornerRadius: 10.0)
                        .fill(rightColor)
                        .scaleEffect(x: rightEdit+rightEdit/65.0, y: 1-rightEdit/20.0, anchor: .leading)
                        .opacity((rightEdit < 0.9) ? rightEdit/1.5 : 1.0)
                    rightIcon
                        .font(.system(size: 14.0, weight: .semibold))
                        .opacity(rightEdit)
                        .offset(x: -10+rightEdit*15)
                    
                    // Drag to the left
                    RoundedRectangle(cornerRadius: 10.0)
                        .fill(leftColor)
                        .scaleEffect(x: leftEdit+leftEdit/65.0, y: 1-leftEdit/20.0, anchor: .trailing)
                        .opacity((leftEdit < 0.9) ? leftEdit/1.5 : 1.0)
                    leftIcon
                        .font(.system(size: 14.0, weight: .semibold))
                        .opacity(leftEdit)
                        .offset(x: 10-leftEdit*15)
                    
                    RoundedRectangle(cornerRadius: 10.0)
                        .stroke(style: .init(lineWidth: 3.0, lineCap: .round, lineJoin: .round, dash: [12.0, 24.0], dashPhase: dashPhase))
                        .animation(.linear(duration: 2.0).repeatForever(autoreverses: false), value: dashPhase)
                        .scaleEffect(x: 1+rightEdit/65.0, y: 1-rightEdit/20.0, anchor: .leading)
                        .scaleEffect(x: 1+leftEdit/65.0, y: 1-leftEdit/20.0, anchor: .trailing)
                        .opacity((currentEdit < 0.9) ? 0.0 : 0.85)
                }
                .animation(.easeInOut(duration: 0.15), value: currentEdit)
            }
            .offset(x: 5*rightEdit - 5*leftEdit)
            .onChange(of: currentEdit) { old, new in
                if (Int(old*10) != Int(new*10)) && (new > old) {
                    NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .now)
                }
            }
            .onAppear { // Produce marching ants animation
                dashPhase = -100.0
            }
    }
}

#Preview {
    EditableCell(selected: true) {
        Text("Hello World!")
    }
}
