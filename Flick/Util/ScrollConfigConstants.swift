//
//  ScrollConfigConstants.swift
//  Flick
//
//  Created by Austin Vesich on 5/30/25.
//

import Foundation
import SwiftUI

struct ScrollConfigConstants {
    static let SEARCH_OPTION_INDEX: Int = 0
    static let NUM_PRE_WINDOW_SCROLL_OPTIONS: Int = 1
    
    static public var SENSITIVITY_MULTIPLIER: Double {
        UserDefaults.standard.double(forKey: "scrollSensitivity") ?? 6.0
    }
    static public var SHORTCUT: Shortcut {
        Shortcut(rawValue: (UserDefaults.standard.integer(forKey: "hotkeyOption") ?? Shortcut.commandTab.rawValue))!
    }
    static public var SELECT_WITH_MOUSE_ENABLED: Bool {
        UserDefaults.standard.bool(forKey: "selectWithMouse") ?? true
    }
}
