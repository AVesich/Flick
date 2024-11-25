//
//  intplus.swift
//  Mini
//
//  Created by Austin Vesich on 11/24/24.
//

import AppKit
import Observation

@Observable class ScrollTrackerState {
    private let SENSITIVITY_MULTIPLIER = 5
    
    public var isTrackingScrolling: Bool = false {
        didSet {
            if !isTrackingScrolling {
                scrollDelta = 0
            }
        }
    }
    public var scrollDelta: Int = 0 {
        didSet {
            if scrollDelta/SENSITIVITY_MULTIPLIER != oldValue/SENSITIVITY_MULTIPLIER { // Click every 5 scroll ticks, but only once when we first enter a range of 5 nums
                NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .now)
                scrolledIdx = scrollDelta/SENSITIVITY_MULTIPLIER
            }
        }
    }
    public var maxDelta: Int {
        (orderedWindows.appIconsWithWindowDescriptions.count-1)*SENSITIVITY_MULTIPLIER
    }
    public var scrolledIdx: Int = 0
    public var orderedWindows = OrderedWindows()
}
