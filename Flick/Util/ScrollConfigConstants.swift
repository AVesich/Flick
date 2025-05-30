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
}
