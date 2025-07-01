//
//  AppCell.swift
//  Flick
//
//  Created by Austin Vesich on 6/18/24.
//

import SwiftUI
import AppKit

struct AppCell: View {
    
    @AppStorage("selectWithMouse") private var selectWithMouse: Bool = true
    @FocusState private var isFocused: Bool
    @State private var hovering: Bool = false
    public var selecting: Bool
    public var app: AppData
    
    var body: some View {
        ZStack(alignment: .trailing) {
            HStack(alignment: .center, spacing: 16.0) {
                IconImage(icon: app.icon)
                VStack(alignment: .leading) {
                    Text(app.name)
                        .lineLimit(1)
                    Text("Open App")
                        .font(.system(size: 8.0))
                        .opacity(0.5)
                }
                Spacer()
            }
            .frame(width: VisualConfigConstants.cellContentWidth, height: VisualConfigConstants.cellContentHeight)
            .padding(VisualConfigConstants.cellPadding)
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
            guard selectWithMouse else { return }
            hovering = hover
        }
        .onTapGesture {
            guard selectWithMouse else { return }
            WindowAppearance.openApp(app)
            NSApp.fakeHide()
        }
        .modifier(ShrinkOnPress(mouseReactivityEnabled: selectWithMouse))
        .modifier(SelectionBasedFocus(isSelected: selecting))
        .onKeyPress(.return) {
            WindowAppearance.openApp(app)
            NSApp.fakeHide()
            return .handled
        }
    }
}

#Preview {
    AppCell(selecting: true,
            app: .init(url: URL(filePath: "/System/Applications/Apps.app")))
}
