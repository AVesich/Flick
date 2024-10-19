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
        VStack(alignment: .leading) {
            if index < 5 {
                Button {
//                    WindowManager.shared.minifyApp(withName: app.name)
                } label: {
                    AppCellContent(app: app, index: index)
                }
                .buttonStyle(HoverButtonStyle())
                .keyboardShortcut(.init("\(index+1)"), modifiers: []) // No modifiers, just press the button
            } else {
                Button {
//                    WindowManager.shared.minifyApp(withName: app.name)
                } label: {
                    AppCellContent(app: app, index: index)
                }
                .buttonStyle(HoverButtonStyle())
            }
            
            if app.windowCount > 1 {
                ForEach(0..<app.windowCount) { idx in
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "macwindow")
                            Text("Window \(idx+1)")
                                .padding(.vertical, 8.0)
                                .font(.system(size: 12.0).weight(.semibold))
                            Spacer()
                        }
                    }
                    .buttonStyle(HoverButtonStyle())
                    .padding(.leading, 24.0)
                }
            }
        }
    }
}

struct AppCellContent: View {
    
    public var app: AppData
    public var index: Int

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 8.0) {
                Image(nsImage: app.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24.0, height: 24.0)
                Text(app.name)
                    .font(.system(size: 14.0).weight(.semibold))
                Spacer()
                Text(app.mini ? "Minified" : "Minify")
                    .font(.system(size: 10.0).weight(.semibold))
                    .opacity(0.5)
                if index < 5 {
                    Text(String("\(index+1)"))
                        .font(.system(size: 14.0).weight(.semibold))
                }
            }
        }
        .padding(.vertical, 10.0)
    }
}

#Preview {
    AppCell(app: AppData(icon: NSImage(systemSymbolName: "app.fill", accessibilityDescription: nil)!,
                         name: "Mini",
                         windowCount: 1,
                         mini: true),
            index: 0)
}
