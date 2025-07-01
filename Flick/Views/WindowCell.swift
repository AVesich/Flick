//
//  WindowCell.swift
//  Mini
//
//  Created by Austin Vesich on 11/25/24.
//

import SwiftUI
import AppKit

struct WindowCell: View {
    
    @AppStorage("selectWithMouse") private var selectWithMouse: Bool = true
    @State private var hovering: Bool = false
    public var selecting: Bool
    public var window: Window
    
    var body: some View {
        ZStack(alignment: .trailing) {
            HStack(alignment: .center, spacing: 16.0) {
                IconImage(icon: window.appIcon)
                Text(window.windowTitle)
                    .lineLimit(1)
                Spacer()
            }
            .frame(width: VisualConfigConstants.cellContentWidth, height: VisualConfigConstants.cellContentHeight)
            .padding(VisualConfigConstants.cellPadding)
            
            if selectWithMouse {
                ZStack(alignment: .trailing) {
                    Rectangle()
                        .fill(LinearGradient(colors: [.clear, .black.opacity(0.8), .black], startPoint: .leading, endPoint: .trailing))
                        .scaleEffect(x: (selecting || hovering) ? 1.0 : 0.0, anchor: .trailing)
                    
                    Button {
                        WindowAppearance.closeWindow(window)
                        NotificationCenter.default.post(name: .deletePressedNotification, object: nil)
                    } label: {
                        Image(systemName: "xmark")
                            .bold()
                            .frame(width: 16.0, height: 16.0)
                            .padding(VisualConfigConstants.cellPadding)
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(HoverButtonStyle())
                    .padding(.trailing, VisualConfigConstants.cellPadding)
                    .opacity((selecting || hovering) ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: VisualConfigConstants.fastAnimationDuration), value: (selecting || hovering))
                }
                .frame(width: 2*VisualConfigConstants.cellHeight, height: VisualConfigConstants.cellHeight)
            }
        }
        .background {
            Rectangle()
                .fill(.secondary.opacity(VisualConfigConstants.selectionOpacity))
                .frame(width: VisualConfigConstants.cellWidth, height: VisualConfigConstants.cellHeight)
                .opacity(selecting ? 1.0 : .minimumDetectable)
                .animation(.easeInOut(duration: VisualConfigConstants.fastAnimationDuration), value: selecting)
        }
        .clipShape(.rect(cornerRadius: VisualConfigConstants.smallCornerRadius))
        .scaleEffect((selecting || hovering) ? 1.05 : 1.0)
        .animation(.bouncy(duration: VisualConfigConstants.slowAnimationDuration, extraBounce: 0.25), value: (selecting || hovering))
        .onHover { hover in
            guard selectWithMouse else { return }
            hovering = hover
        }
        .onTapGesture {
            guard selectWithMouse else { return }
            WindowAppearance.openWindow(window)
            NSApp.fakeHide()
        }
        .modifier(ShrinkOnPress(mouseReactivityEnabled: selectWithMouse))
        .modifier(SelectionBasedFocus(isSelected: selecting))
        .onKeyPress(.return) {
            WindowAppearance.openWindow(window)
            NSApp.fakeHide()
            return .handled
        }
        .onKeyPress(.init(Character(UnicodeScalar(127)))) {
            WindowAppearance.closeWindow(window)
            NotificationCenter.default.post(name: .deletePressedNotification, object: nil)
            return .handled
        }
        .onHotkeyUp {
            if selecting {
                WindowAppearance.openWindow(window)
                NSApp.fakeHide()
            }
        }
    }
}
