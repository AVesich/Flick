//
//  Shortcut.swift
//  Flick
//
//  Created by Austin Vesich on 6/21/25.
//

import CoreGraphics

enum Shortcut: Int, Codable, Equatable {
    case controlTab
    case optionTab
    case commandTab
        
    // MARK: - Properties
    var modifierKeyString: String {
        switch self {
        case .controlTab:
            return "⌃"
        case .optionTab:
            return "⌥"
        case .commandTab:
            return "⌘"
        }
    }
    
    // MARK: - Utility Methods
    public func isPressed(event: CGEvent) -> Bool {
        let tabPressed = event.getIntegerValueField(.keyboardEventKeycode) == TAB_KEYCODE
        var modifierPressed = false
        
        switch self {
        case .controlTab:
            modifierPressed = event.flags.contains(.maskControl)
        case .optionTab:
            modifierPressed = event.flags.contains(.maskAlternate)
        case .commandTab:
            modifierPressed = event.flags.contains(.maskCommand)
        }

        return tabPressed && modifierPressed
    }
}
