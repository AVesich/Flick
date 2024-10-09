//
//  HoverCell.swift
//  Mini
//
//  Created by Austin Vesich on 10/8/24.
//

import SwiftUI

struct AppCell: View {
    
    @State private var isSelected = false
    public var app: AppData
    public var index: Int

    var body: some View {
        if index < 5 {
            Button {
                WindowManager.shared.minifyApp(withName: app.name)
            } label: {
                AppCellContent(app: app, index: index)
            }
            .buttonStyle(.plain)
            .keyboardShortcut(.init(Character("\(index+1)")), modifiers: []) // No modifiers, just press the button
        } else {
            Button {
                WindowManager.shared.minifyApp(withName: app.name)
            } label: {
                AppCellContent(app: app, index: index)
            }
            .buttonStyle(.plain)
        }
    }
}

struct AppCellContent: View {
    
    @State private var isHovering = false
    public var app: AppData
    public var index: Int

    var body: some View {
        HStack(spacing: 16.0) {
            Image(nsImage: app.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 24.0, height: 24.0)
            Text(app.name)
                .font(.system(size: 14.0).monospaced())
            Spacer()
            Text(app.mini ? "Minified" : "Minify")
                .font(.system(size: 10.0).monospaced())
                .opacity(0.5)
            if index < 5 {
                Text(String("\(index+1)"))
                    .font(.system(size: 14.0).monospaced())
            }
        }
        .padding(.horizontal, 16.0)
        .padding(.vertical, 10.0)
        .background {
            if isHovering {
                RoundedRectangle(cornerRadius: 8.0)
                    .fill(.white.opacity(0.1))
            }
        }
        .onHover { hovering in
            isHovering = hovering
        }
        .animation(.easeInOut(duration: 0.1), value: isHovering)
    }
}

#Preview {
    AppCell(app: AppData(icon: NSImage(systemSymbolName: "app.fill", accessibilityDescription: nil)!,
                         name: "Mini",
                         mini: true),
            index: 0)
}
