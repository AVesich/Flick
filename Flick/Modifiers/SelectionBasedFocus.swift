//
//  SelectionBasedFocus.swift
//  Flick
//
//  Created by Austin Vesich on 6/20/25.
//

import SwiftUI

struct SelectionBasedFocus: ViewModifier {
    @FocusState private var isFocused: Bool
    public var isSelected: Bool
    
    func body(content: Content) -> some View {
        content
            .focusable()
            .focusEffectDisabled()
            .focused($isFocused)
            .onAppear {
                isFocused = isSelected
//                print(isFocused)
            }
            .onChange(of: isSelected) {
                isFocused = isSelected
//                print(isFocused)
            }
    }
}
