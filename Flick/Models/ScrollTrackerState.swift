//
//  intplus.swift
//  Mini
//
//  Created by Austin Vesich on 11/24/24.
//

import AppKit
import Observation

@Observable class ScrollTrackerState {
    // MARK: - General Public Properties
    public var isSwitching: Bool = false {
        didSet {
            if isSwitching { // Upon appearance, reset the vertical scroll delta
                vertScrolledIdx = ScrollConfigConstants.NUM_PRE_WINDOW_SCROLL_OPTIONS
                vertScrollDelta = 0
            }
        }
    }
    public var isArrangingWindows: Bool = false
    
    // MARK: - Vertical Scrolling
    public var vertScrollDelta: Int = 0 {
        didSet {
            if oldValue != vertScrollDelta {
                vertScrolledIdx = ScrollConfigConstants.NUM_PRE_WINDOW_SCROLL_OPTIONS + vertScrollDelta/ScrollConfigConstants.VERT_SENSITIVITY_MULTIPLIER
            }
        }
    }
    public var maxVertDelta: Int {
        return (orderedWindows.appIconsWithWindowDescriptionsAndPIDs.count-1) * ScrollConfigConstants.VERT_SENSITIVITY_MULTIPLIER
    }
    public var vertScrolledIdx: Int = ScrollConfigConstants.NUM_PRE_WINDOW_SCROLL_OPTIONS
        
    // MARK: - Selection
    // These should be manually changed by whatever handles the selection
    public var hasSelectedVertical: Bool = false
    
    // MARK: - Window list updating
    public var windowData: [Window] {
        orderedWindows.appIconsWithWindowDescriptionsAndPIDs
    }
    private var orderedWindows = OrderedWindows()
    
    public func updateAppList() async {
        await orderedWindows.updateAppList()
    }
}
