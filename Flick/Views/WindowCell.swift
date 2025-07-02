//
//  WindowCell.swift
//  Mini
//
//  Created by Austin Vesich on 11/25/24.
//

import SwiftUI
import AppKit

struct WindowCell: View {
    
    @EnvironmentObject private var search: Search
    @AppStorage("selectWithMouse") private var selectWithMouse: Bool = true
    @State private var hovering: Bool = false
    @State private var isPressed: Bool = false
    public var index: Int
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
            .background {
                Rectangle()
                    .fill(.secondary.opacity(VisualConfigConstants.selectionOpacity))
                    .frame(width: VisualConfigConstants.cellWidth, height: VisualConfigConstants.cellHeight)
                    .opacity(selecting ? 1.0 : .minimumDetectable)
                    .animation(.easeInOut(duration: VisualConfigConstants.fastAnimationDuration), value: selecting)
            }
            .clipShape(.rect(cornerRadius: VisualConfigConstants.smallCornerRadius))
            .modifier(ShrinkOnPress(mouseReactivityEnabled: selectWithMouse, isPressed: $isPressed))
            
            if selectWithMouse {
                ZStack(alignment: .trailing) {
                    Rectangle()
                        .fill(LinearGradient(colors: [.clear, .black.opacity(0.8), .black], startPoint: .leading, endPoint: .trailing))
                        .scaleEffect(x: ((selecting || hovering) && !isPressed) ? 1.0 : 0.0, anchor: .trailing)
                        
                    Button {
                        WindowAppearance.closeWindow(window)
                        withAnimation(.easeInOut(duration: VisualConfigConstants.fastAnimationDuration)) {
                            _ = search.results.remove(at: index)
                        }
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
                    .opacity(((selecting || hovering) && !isPressed) ? 1.0 : 0.0)
                }
                .frame(width: 2*VisualConfigConstants.cellHeight, height: VisualConfigConstants.cellHeight)
                .animation(.easeInOut(duration: VisualConfigConstants.fastAnimationDuration), value: selecting)
                .animation(.easeInOut(duration: VisualConfigConstants.fastAnimationDuration), value: hovering)
                .animation(.easeInOut(duration: VisualConfigConstants.fastAnimationDuration), value: isPressed)
            }
        }
        .clipShape(.rect(cornerRadius: VisualConfigConstants.smallCornerRadius))
        .scaleEffect((selecting || hovering) ? 1.04 : 1.0)
        .onHover { hover in
            guard selectWithMouse else { return }
            hovering = hover
        }
        .animation(.bouncy(duration: VisualConfigConstants.slowAnimationDuration, extraBounce: 0.25), value: (selecting || hovering))
        .onTapGesture {
            guard selectWithMouse else { return }
            WindowAppearance.openWindow(window)
            NSApp.fakeHide()
        }
        .modifier(SelectionBasedFocus(isSelected: selecting))
        .onKeyPress(.return) {
            WindowAppearance.openWindow(window)
            NSApp.fakeHide()
            return .handled
        }
        .onKeyPress(.init(Character(UnicodeScalar(127)))) {
            WindowAppearance.closeWindow(window)
            // TODO: - Pass in index, remove window from search.results here
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
