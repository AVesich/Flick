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
           let scrollEvent = registerScrollEvent() {
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
        print("registering hotkey event")
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
    if event.getIntegerValueField(.keyboardEventKeycode) == Keys.keyCode(for: "z")
       && event.flags.contains(.maskSecondaryFn)
       , let argRef = refcon {

        let ptr = argRef.assumingMemoryBound(to: UnsafeMutableRawPointer.self)
        let tracker = Unmanaged<ScrollTrackerState>.fromOpaque(ptr).takeUnretainedValue()
        
        if !tracker.isSwitching {
            tracker.isSwitching = true
            DispatchQueue.main.async {
                Task {
                    await tracker.updateAppList()
                    NSApp.activate(ignoringOtherApps: true)
                }
            }
        }
        return nil // Don't pass input through any fn + z
    }
    
    return Unmanaged.passUnretained(event) // Passthrough this input, no harm in doing so
}

func fnzUp(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    guard let argRef = refcon else {
        return Unmanaged.passUnretained(event)
    }
    let ptr = argRef.assumingMemoryBound(to: UnsafeMutableRawPointer.self)
    let tracker = Unmanaged<ScrollTrackerState>.fromOpaque(ptr).takeUnretainedValue()
    
    if (event.getIntegerValueField(.keyboardEventKeycode) == Keys.keyCode(for: "z") || event.flags.contains(.maskSecondaryFn))
        && tracker.isSwitching {
        tracker.hasSelectedVertical = true
        tracker.isSwitching = false
//        && !tracker.orderedWindows.appIconsWithWindowDescriptionsAndPIDs.isEmpty
//        && !tracker.isSelectingHoriScrolling {
//        
//        let selectedWindowData = tracker.orderedWindows.appIconsWithWindowDescriptionsAndPIDs[tracker.vertScrollDelta/tracker.SENSITIVITY_MULTIPLIER]
//        let selectedWindowIndex = selectedWindowData.2
//        let selectedWindowPID = selectedWindowData.3
//        openWindow(windowIndex: selectedWindowIndex, pid: selectedWindowPID)
//        NSRunningApplication(processIdentifier: selectedWindowPID)?.activate()//.activate(options: .activateIgnoringOtherApps)
        
        return nil // Don't pass input through
    }
    
    return Unmanaged.passUnretained(event) // Passthrough this input, no harm in doing so
}

// All horizontal scroll values here are negative because a pan left triggers delete and also produces a negative value
func scrollHandler(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    guard let argRef = refcon, event.flags.contains(.maskSecondaryFn) else {
        return Unmanaged.passUnretained(event)
    }
    let ptr = argRef.assumingMemoryBound(to: UnsafeMutableRawPointer.self)
    let tracker = Unmanaged<ScrollTrackerState>.fromOpaque(ptr).takeUnretainedValue()
    
    let vertDelta = event.getIntegerValueField(.scrollWheelEventDeltaAxis1)
    let horiDelta = event.getDoubleValueField(.scrollWheelEventDeltaAxis2)
    let scrollEnded = Set<Int>([0, 4, 8]).contains(Int(event.getIntegerValueField(.scrollWheelEventScrollPhase))) // 2 seems to be actively scrolling, 128 is starting/pre-scroll states
    
//    if scrollEnded { // Only horizontal scrolls should reset when lifting the fingers, vertical delta is based on the "session" produced by opening the window until it's closed
//        if fabs(tracker.horiScrollDelta) > tracker.HORI_SCROLL_SELECTION_THRESHOLD {
//            tracker.hasSelectedHorizontal = true
//        } else { // Reset drag delta if selection is not made; Selections reset the drag delta after action is taken in the selection handler
//            tracker.horiScrollDelta = 0.0
//        }
//        return nil
//    } else {
//        tracker.horiScrollDelta = min(max(-10.0, tracker.horiScrollDelta+horiDelta), 10.0)
//        if fabs(tracker.horiScrollDelta) > tracker.HORI_SCROLL_LOCK_THRESHOLD {
//            return nil
//        }
//    }
    
    tracker.vertScrollDelta = min(max(0, tracker.vertScrollDelta+Int(vertDelta)), tracker.maxVertDelta)
    return nil // Don't pass the vertical scroll action to the scrollview
}
