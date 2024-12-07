//
//  intplus.swift
//  Mini
//
//  Created by Austin Vesich on 11/24/24.
//

import AppKit
import Observation

@Observable class ScrollTrackerState {
    public let VERT_SENSITIVITY_MULTIPLIER = 5
    public let HORI_SENSITIVITY_MULTIPLIER = 10.0
    
    // MARK: - General Public Properties
    public var isSwitching: Bool = false {
        didSet {
            if isSwitching { // Upon appearance, reset the vertical scroll delta
                vertScrollDelta = 0
            }
            if !isSwitching && isArrangingWindows {
                isArrangingWindows = false
                hasSelectedHorizontal = false
            }
        }
    }
    public var isArrangingWindows: Bool = false {
        didSet {
//            if !isArrangingWindows { // If arranging stops, switching windows should stop so that the arranged window is brought to the front
//                isSwitching = false
//            }
        }
    }
    
    // MARK: - Vertical Scrolling
    public var vertScrollDelta: Int = 0 {
        didSet {
            if vertScrollDelta/VERT_SENSITIVITY_MULTIPLIER != oldValue/VERT_SENSITIVITY_MULTIPLIER { // Click every 5 scroll ticks, but only once when we first enter a range of 5 nums
                vertScrolledIdx = vertScrollDelta/VERT_SENSITIVITY_MULTIPLIER
            }
        }
    }
    public var maxVertDelta: Int {
        (orderedWindows.appIconsWithWindowDescriptionsAndPIDs.count-1)*VERT_SENSITIVITY_MULTIPLIER
    }
    public var vertScrolledIdx: Int = 0
    
    // MARK: - Horizontal Scrolling
    public var HORI_SCROLL_SELECTION_THRESHOLD: CGFloat = 11.0
    public var HORI_SCROLL_LOCK_THRESHOLD: CGFloat = 2.0
    public var horiScrollDelta: CGFloat = 0.0
    public var horiScrolledPct: CGFloat {
        if abs(horiScrollDelta) > HORI_SCROLL_LOCK_THRESHOLD {
            return (horiScrollDelta < 0.0) ? (horiScrollDelta+HORI_SCROLL_LOCK_THRESHOLD)/HORI_SENSITIVITY_MULTIPLIER :
                                             (horiScrollDelta-HORI_SCROLL_LOCK_THRESHOLD)/HORI_SENSITIVITY_MULTIPLIER
        } else {
            return 0.0
        }
    }
    
    // MARK: - Selection
    // These should be manually changed by whatever handles the selection
    public var hasSelectedHorizontal: Bool = false {
        didSet {
            if hasSelectedHorizontal == false { // A selection has been made (a window has been removed), reset the vertical index to 0 to immediately return to the frontmost window
                vertScrollDelta = 0
            }
        }
    }
    public var hasSelectedVertical: Bool = false
    
    // MARK: - Window list updating
    public var windowData: [(NSImage, String, Int, pid_t)] {
        orderedWindows.appIconsWithWindowDescriptionsAndPIDs
    }
    private var orderedWindows = OrderedWindows()
    
    public func updateAppList() async {
        await orderedWindows.updateAppList()
    }
}
