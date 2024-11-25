//
//  intplus.swift
//  Mini
//
//  Created by Austin Vesich on 11/24/24.
//

import AppKit
import Observation

@Observable class ScrollTrackerState {
    var isTrackingScrolling: Bool = false {
        didSet {
            if !isTrackingScrolling {
                scrollDelta = 0
            }
        }
    }
    var scrollDelta: Int = 0 {
        didSet {
            print(scrollDelta/5)
            if scrollDelta/5 != oldValue/5 { // Click every 5 scroll ticks, but only once when we first enter a range of 5 nums
                NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .now)
            }
        }
    }
}
