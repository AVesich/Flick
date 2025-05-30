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
    public var hovering: Bool
    public var window: Window
    
    var body: some View {
        HStack(alignment: .center, spacing: 16.0) {
            Image(nsImage: window.appIcon)
                .resizable()
                .frame(width: 30.0, height: 30.0)
                .scaledToFit()
                .scaleEffect(hovering ? 1.2 : 1.0)
            Text(window.windowTitle)
                .lineLimit(2)
                .scaleEffect(hovering ? 1.07 : 1.0)
            Spacer()
        }
        .frame(width: VisualConfigConstants.cellContentWidth, height: VisualConfigConstants.cellContentHeight)
        .padding(VisualConfigConstants.cellPadding)
        .background {
            if hovering {
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(.secondary.opacity(VisualConfigConstants.selectionOpacity))
                    .frame(width: VisualConfigConstants.cellWidth, height: VisualConfigConstants.cellHeight)
            }
        }
        .animation(.bouncy(duration: 0.2, extraBounce: 0.15), value: hovering)
        .onChange(of: scrollState.hasSelectedVertical) { _, selected in
            guard hovering else { return }
                        
            if selected == true {
                OrderedWindows.openWindow(windowIndex: window.windowNumber,
                                          pid: window.appPID)
                scrollState.hasSelectedVertical = false
            }
        }

    }
}
