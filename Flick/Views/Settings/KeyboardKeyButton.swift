//
//  KeyboardKeyButton.swift
//  Flick
//
//  Created by Austin Vesich on 6/21/25.
//

import SwiftUI

struct KeyboardKeyButton: View {
    @Binding public var selectedShortcut: Shortcut
    public let shortcutType: Shortcut
//    private var selected: Bool {
//        
//    }
    
    var body: some View {
        Button {
            print(selectedShortcut)
            selectedShortcut = shortcutType
            print(selectedShortcut)
        } label: {
            VStack {
                HStack {
                    KeyboardKeyView(keyText: shortcutType.modifierKeyString)
                    KeyboardKeyView(keyText: "tab")
                }
                
                Image(systemName: (selectedShortcut == shortcutType) ? "checkmark.circle.fill" : "circle")
                    .imageScale(.large)
                    .foregroundStyle((selectedShortcut == shortcutType) ? .blue : .white)
            }
            .padding(16.0)
            .background((selectedShortcut == shortcutType) ? .blue.opacity(VisualConfigConstants.selectionOpacity) : .black.opacity(.minimumDetectable))
        }
        .buttonStyle(.plain)
        .clipShape(.rect(cornerRadius: VisualConfigConstants.smallCornerRadius))
        .animation(.easeInOut(duration: VisualConfigConstants.fastAnimationDuration), value: selectedShortcut)
        .onChange(of: selectedShortcut) {
            print("\(shortcutType), \(selectedShortcut == shortcutType)")
        }
    }
}

#Preview {
    KeyboardKeyButton(selectedShortcut: .constant(Shortcut.commandTab), shortcutType: .commandTab)
}
