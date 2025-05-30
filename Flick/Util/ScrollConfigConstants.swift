//
//  ScrollConfigConstants.swift
//  Flick
//
//  Created by Austin Vesich on 5/30/25.
//

import Foundation

struct ScrollConfigConstants {
    static let NUM_PRE_WINDOW_SCROLL_OPTIONS: Int = 1
    static let MIN_VERT_DELTA: Int = -1 * NUM_PRE_WINDOW_SCROLL_OPTIONS * VERT_SENSITIVITY_MULTIPLIER
    
    static let VERT_SENSITIVITY_MULTIPLIER: Int = 6
    
    static let HORI_SENSITIVITY_MULTIPLIER: CGFloat = 10.0
    static let HORI_SCROLL_SELECTION_THRESHOLD: CGFloat = 11.0
    static let HORI_SCROLL_LOCK_THRESHOLD: CGFloat = 2.0
}
