//
//  intplus.swift
//  Mini
//
//  Created by Austin Vesich on 11/24/24.
//

import AppKit
import Observation

@Observable class ScrollTrackerState {
    public let SENSITIVITY_MULTIPLIER = 5
    
    public var isTrackingScrolling: Bool = false {
        didSet {
            if !isTrackingScrolling {
                vertScrollDelta = 0
            }
        }
    }
    public var vertScrollDelta: Int = 0 {
        didSet {
            if vertScrollDelta/SENSITIVITY_MULTIPLIER != oldValue/SENSITIVITY_MULTIPLIER { // Click every 5 scroll ticks, but only once when we first enter a range of 5 nums
                scrolledIdx = vertScrollDelta/SENSITIVITY_MULTIPLIER
                horiScrollDelta = 0 // Reset horizontal scrolling when a new window is selected
            }
        }
    }
    public var maxVertDelta: Int {
        (orderedWindows.appIconsWithWindowDescriptionsAndPIDs.count-1)*SENSITIVITY_MULTIPLIER
    }
    public var horiScrollDelta: CGFloat = 0.0
    public var scrolledIdx: Int = 0
    public var orderedWindows = OrderedWindows()
    
    public func updateAppList() async {
        await orderedWindows.updateAppList()
    }
}
