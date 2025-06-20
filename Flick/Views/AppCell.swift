//
//  WindowCell.swift
//  Mini
//
//  Created by Austin Vesich on 11/25/24.
//

import SwiftUI
import AppKit

struct WindowCell: View {
    
    public var scrollState: ScrollTrackerState
    public var selecting: Bool
    @State private var hovering: Bool = false
    public var window: Window
    
    var body: some View {
        ZStack(alignment: .trailing) {
            HStack(alignment: .center, spacing: 16.0) {
                Image(nsImage: window.appIcon)
                    .resizable()
                    .frame(width: 30.0, height: 30.0)
                    .scaledToFit()
                Text(window.windowTitle)
                    .lineLimit(1)
                Spacer()
            }
            .frame(width: VisualConfigConstants.cellContentWidth, height: VisualConfigConstants.cellContentHeight)
            .padding(VisualConfigConstants.cellPadding)

            ZStack(alignment: .trailing) {
                Rectangle()
                    .fill(LinearGradient(colors: [.clear, .black.opacity(0.8), .black], startPoint: .leading, endPoint: .trailing))
                    .scaleEffect(x: (selecting || hovering) ? 1.0 : 0.0, anchor: .trailing)

                Button {
                    scrollState.closeWindow(window)
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
        .background {
            RoundedRectangle(cornerRadius: VisualConfigConstants.smallCornerRadius)
                .fill(.secondary.opacity(VisualConfigConstants.selectionOpacity))
                .frame(width: VisualConfigConstants.cellWidth, height: VisualConfigConstants.cellHeight)
                .opacity(selecting ? 1.0 : .minimumDetectable)
                .animation(.easeInOut(duration: VisualConfigConstants.fastAnimationDuration), value: selecting)
        }
        .scaleEffect((selecting || hovering) ? 1.05 : 1.0)
        .animation(.bouncy(duration: VisualConfigConstants.slowAnimationDuration, extraBounce: 0.25), value: (selecting || hovering))
        .onHover { hover in
            hovering = hover
        }
        .onTapGesture {
            scrollState.selectWindowAndCloseApp(window)
        }
        .modifier(ShrinkOnPress())
    }
}
