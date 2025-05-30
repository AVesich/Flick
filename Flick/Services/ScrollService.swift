//
//  HotkeyLoop.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import CoreGraphics
import AppKit
import ApplicationServices
import Observation

@MainActor
@Observable class ScrollService {
    // MARK: - Tracking Scrolling state
    public var scrollState = ScrollTrackerState()
    private var started: Bool = false
    
    // MARK: - Initialization
    init() {
        if started {
            return
        }
        started = true
        
        if let keyDownEvent = registerKeyDownEvent(),
           let keyUpEvent = registerKeyUpEvent(),
           let scrollEvent = registerScrollEvent()
        {
            Task {
                startRunLoopForEvent(keyDownEvent)
            }
            Task {
                startRunLoopForEvent(keyUpEvent)
            }
            Task {
                startRunLoopForEvent(scrollEvent)
            }
        } else {
            // TODO: - Show oops dialog
        }
    }
        
    // MARK: - Event registration
    private func registerKeyDownEvent() -> CFMachPort? {
        let buttonDownBitMask = 1 << CGEventType.keyDown.rawValue
        let buttonDownMask = CGEventMask(buttonDownBitMask)
        let ptr = UnsafeMutableRawPointer(Unmanaged.passUnretained(scrollState).toOpaque())
        return CGEvent.tapCreate(tap: .cgSessionEventTap,
                                 place: .tailAppendEventTap,
                                 options: .defaultTap,
                                 eventsOfInterest: buttonDownMask,
                                 callback: fnzDown,
                                 userInfo: ptr)
    }
    
    private func registerKeyUpEvent() -> CFMachPort? {
        let buttonDownBitMask = 1 << CGEventType.keyUp.rawValue
        let buttonDownMask = CGEventMask(buttonDownBitMask)
        let ptr = UnsafeMutableRawPointer(Unmanaged.passUnretained(scrollState).toOpaque())
        return CGEvent.tapCreate(tap: .cgSessionEventTap,
                                 place: .tailAppendEventTap,
                                 options: .defaultTap,
                                 eventsOfInterest: buttonDownMask,
                                 callback: fnzUp,
                                 userInfo: ptr)
    }
    
    private func registerScrollEvent() -> CFMachPort? {
        let scrollBitMask = 1 << CGEventType.scrollWheel.rawValue
        let scrollMask = CGEventMask(scrollBitMask)
        let ptr = UnsafeMutableRawPointer(Unmanaged.passUnretained(scrollState).toOpaque())
        return CGEvent.tapCreate(tap: .cgSessionEventTap,
                                 place: .tailAppendEventTap,
                                 options: .defaultTap,
                                 eventsOfInterest: scrollMask,
                                 callback: scrollHandler,
                                 userInfo: ptr)
    }
    
    // MARK: - Event running
    // For context, CFRunLoop is in charge of control & input dispatch for a task
    private func startRunLoopForEvent(_ event: CFMachPort) {
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, event, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: event, enable: true)
        CFRunLoopRun()
    }
}

// MARK: - Event handling
func fnzDown(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    if event.getIntegerValueField(.keyboardEventKeycode) == Keys.keyCode(for: "tab") && event.flags.contains(.maskAlternate),
       let stateRef = refcon {

        let ptr = stateRef.assumingMemoryBound(to: UnsafeMutableRawPointer.self)
        let tracker = Unmanaged<ScrollTrackerState>.fromOpaque(ptr).takeUnretainedValue()
        
        if !tracker.isSwitching {
            tracker.isSwitching = true
            DispatchQueue.main.async {
                Task {
                    await tracker.updateAppList()
                    NSApp.activate(ignoringOtherApps: true)
                    NSApp.windows.first?.makeKeyAndOrderFront(nil)
                }
            }
        }
        return nil // Don't pass input through any fn + z
    }
    
    return Unmanaged.passUnretained(event) // Passthrough this input, no harm in doing so
}

func fnzUp(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    guard let stateRef = refcon else {
        return Unmanaged.passUnretained(event)
    }
    let ptr = stateRef.assumingMemoryBound(to: UnsafeMutableRawPointer.self)
    let tracker = Unmanaged<ScrollTrackerState>.fromOpaque(ptr).takeUnretainedValue()
    
    if (event.getIntegerValueField(.keyboardEventKeycode) == Keys.keyCode(for: "tab") || event.flags.contains(.maskCommand)) {
        if tracker.isSwitching {
            if !tracker.hasSelectedHorizontal {
                tracker.hasSelectedVertical = true
            }
            tracker.isSwitching = false
        }
        if tracker.isArrangingWindows {
            tracker.isArrangingWindows = false
        }
        
        return nil // Don't pass input through
    }
    
    return Unmanaged.passUnretained(event) // Passthrough this input, no harm in doing so
}

// All horizontal scroll values here are negative because a pan left triggers delete and also produces a negative value
func scrollHandler(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    guard let argRef = refcon else {
        return Unmanaged.passUnretained(event)
    }
    let ptr = argRef.assumingMemoryBound(to: UnsafeMutableRawPointer.self)
    let tracker = Unmanaged<ScrollTrackerState>.fromOpaque(ptr).takeUnretainedValue()
    
    if tracker.isArrangingWindows || !tracker.isSwitching {
        return Unmanaged.passUnretained(event)
    }
    
    let vertDelta = event.getIntegerValueField(.scrollWheelEventDeltaAxis1)
//    let horiDelta = event.getDoubleValueField(.scrollWheelEventDeltaAxis2)
    let scrollEnded = Set<Int>([0, 4, 8]).contains(Int(event.getIntegerValueField(.scrollWheelEventScrollPhase))) // 2 seems to be actively scrolling, 128 is starting/pre-scroll states
    
//    if scrollEnded { // Only horizontal scrolls should reset when lifting the fingers, vertical delta is based on the "session" produced by opening the window until it's closed
//        if fabs(tracker.horiScrollDelta) > ScrollConfigConstants.HORI_SCROLL_SELECTION_THRESHOLD {
//            tracker.hasSelectedHorizontal = true
//        } else { // Reset drag delta if selection is not made; Selections reset the drag delta after action is taken in the selection handler
//            tracker.horiScrollDelta = 0.0
//        }
//    } else {
//        tracker.horiScrollDelta = min(max(-ScrollConfigConstants.HORI_SCROLL_SELECTION_THRESHOLD-1.0, tracker.horiScrollDelta+horiDelta), ScrollConfigConstants.HORI_SCROLL_SELECTION_THRESHOLD+1.0)
//        if fabs(tracker.horiScrollDelta) > ScrollConfigConstants.HORI_SCROLL_LOCK_THRESHOLD { // Don't allow vertical input after horizontal scroll scrosses the threshold
//            return nil
//        }
//    }
    
    tracker.vertScrollDelta = min(max(ScrollConfigConstants.MIN_VERT_DELTA, tracker.vertScrollDelta+Int(vertDelta)), tracker.maxVertDelta)
    return nil // Don't pass the vertical scroll action to the scrollview
}
