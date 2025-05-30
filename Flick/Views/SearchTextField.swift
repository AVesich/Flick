//
//  SearchTextField.swift
//  Mini
//
//  Created by Austin Vesich on 5/29/25.
//

import SwiftUI

struct SearchTextField: View {
    
    @FocusState var isFocused: Bool
    @Binding var text: String
    public var hovering: Bool
    public let placeholder: String
    
    var body: some View {
        HStack {
            TextField(text: $text, prompt: Text(placeholder)) {}
                .focused($isFocused)
                .frame(width: hovering ? VisualConfigConstants.cellContentWidth : 96.0, height: 20.0)
                .padding(.vertical, VisualConfigConstants.cellPadding)
                .padding(.horizontal, hovering ? VisualConfigConstants.cellPadding : VisualConfigConstants.windowPadding)
                .textFieldStyle(.plain)
                .overlay {
                    HStack {
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .opacity(0.3)
                    }
                    .padding(VisualConfigConstants.cellPadding)
                }
                .background {
                    RoundedRectangle(cornerRadius: hovering ? 10.0 : 16.0)
                        .fill(.secondary.opacity(VisualConfigConstants.selectionOpacity))
                }
                .onChange(of: hovering) { _, hovering in
                    if hovering {
                        isFocused = true
                    } else {
                        isFocused = false
                    }
                }
                
        }
        .animation(.bouncy(duration: 0.15), value: hovering)
    }
}

#Preview {
    SearchTextField(text: .constant(""), hovering: false, placeholder: "Open an app...")
}
