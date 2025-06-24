//
//  intplus.swift
//  Mini
//
//  Created by Austin Vesich on 11/24/24.
//

import SwiftUI
import Observation

class ScrollTrackingSharedState {
    
    // MARK: - Singleton instance
    // Singleton used because this acts as a bridge between the main app and ScrollService, and there's no need to track these values across multiple instances
    public static let shared = ScrollTrackingSharedState()
    
    // MARK: - Status
    public var isSearching: Bool {
        return true
//        return scrollIdx == ScrollConfigConstants.SEARCH_OPTION_INDEX
    }
    
    public var hotkeyDown: Bool = false
    
    // MARK: - Vertical Scrolling
    public var scrollDelta: Int = 0 {
        didSet {
            if scrollDelta >= Int(ScrollConfigConstants.SENSITIVITY_MULTIPLIER) {
                NotificationCenter.default.post(name: .didScrollDownNotification, object: nil)
                scrollDelta = 0
            } else if scrollDelta <= -Int(ScrollConfigConstants.SENSITIVITY_MULTIPLIER) {
                NotificationCenter.default.post(name: .didScrollUpNotification, object: nil)
                scrollDelta = 0
            }
        }
    }
}
