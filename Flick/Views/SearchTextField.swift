//
//  SearchTextField.swift
//  Mini
//
//  Created by Austin Vesich on 5/29/25.
//

import SwiftUI

struct SearchTextField: View {
    
    @Binding var text: String
    public var selecting: Bool
    private var placeholder: String {
        return selecting ? "Search or Open app..." : "Search"
    }
    private let maxWidth = VisualConfigConstants.cellWidth - 2*VisualConfigConstants.windowPadding
    
    var body: some View {
        TextField(text: $text, prompt: Text(placeholder)) {}
            .modifier(SelectionBasedFocus(isSelected: selecting))
            .frame(width: selecting ? maxWidth : 96.0, height: selecting ? 30.0 : VisualConfigConstants.searchBarHeight)
            .padding(.vertical, VisualConfigConstants.cellPadding)
            .padding(.horizontal, VisualConfigConstants.windowPadding)
            .textFieldStyle(.plain)
            .overlay {
                HStack {
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .opacity(0.3)
                }
                .padding(.horizontal, VisualConfigConstants.windowPadding)
            }
            .background {
                RoundedRectangle(cornerRadius: selecting ? VisualConfigConstants.smallCornerRadius : 17.0)
                    .fill(.secondary.opacity(VisualConfigConstants.selectionOpacity))
            }
    }
}

#Preview {
    SearchTextField(text: .constant(""), selecting: false)
}
