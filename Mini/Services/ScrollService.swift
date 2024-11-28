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
    public var windows: [(NSImage, String, Int, pid_t)] {
        return scrollState.orderedWindows.appIconsWithWindowDescriptionsAndPIDs
    }
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
        
        if !tracker.isTrackingScrolling {
            tracker.isTrackingScrolling = true
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
       && tracker.isTrackingScrolling {
        
        let selectedWindowData = tracker.orderedWindows.appIconsWithWindowDescriptionsAndPIDs[tracker.vertScrollDelta/tracker.SENSITIVITY_MULTIPLIER]
        let selectedWindowIndex = selectedWindowData.2
        let selectedWindowPID = selectedWindowData.3
        tracker.isTrackingScrolling = false // Tracking ending happens here because it will reset scrollDelta in the previous line and the next line stalling should not affect performance
        openWindow(windowIndex: selectedWindowIndex, pid: selectedWindowPID)
        NSRunningApplication(processIdentifier: selectedWindowPID)?.activate()//.activate(options: .activateIgnoringOtherApps)
        
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
    let scrollState = event.getIntegerValueField(.scrollWheelEventScrollPhase)
    let scrollEnded = scrollState == 4 || scrollState == 8 || scrollState == 0 // 2 seems to be actively scrolling, 128 is starting/pre-scroll states
    
    if scrollEnded { // Only horizontal scrolls should reset when lifting the fingers, vertical delta is based on the "session" produced by opening the window until it's closed
        if tracker.horiScrollDelta <= -9.0 {
            let windowData = tracker.orderedWindows.appIconsWithWindowDescriptionsAndPIDs[tracker.scrolledIdx]
            closeWindow(windowIndex: windowData.2, pid: windowData.3)
        }
        tracker.horiScrollDelta = 0
    } else {
        tracker.horiScrollDelta = min(max(-10.0, tracker.horiScrollDelta+horiDelta), 0.0)
    }
    
    if tracker.horiScrollDelta >= -1.0 {
        tracker.vertScrollDelta = min(max(0, tracker.vertScrollDelta+Int(vertDelta)), tracker.maxVertDelta)
        return nil // Don't pass the scroll action to the scrollview
    }
    
    return Unmanaged.passUnretained(event)
}

func openWindow(windowIndex index: Int, pid: pid_t) {
    let element = AXUIElementCreateApplication(pid)
    var windows: CFArray?
    let error = AXUIElementCopyAttributeValues(element, kAXWindowsAttribute as CFString, 0, 99999, &windows)
    
    if error == .success, let windows, CFArrayGetCount(windows) > index {
        let window = unsafeBitCast(CFArrayGetValueAtIndex(windows, index), to: AXUIElement.self)
        AXUIElementPerformAction(window, kAXRaiseAction as CFString)
    }
}

func closeWindow(windowIndex index: Int, pid: pid_t) {
    let element = AXUIElementCreateApplication(pid)
    var windows: CFArray?
    let windowError = AXUIElementCopyAttributeValues(element, kAXWindowsAttribute as CFString, 0, 99999, &windows)
      
    if windowError == .success, let windows, CFArrayGetCount(windows) > index {
        let window = unsafeBitCast(CFArrayGetValueAtIndex(windows, index), to: AXUIElement.self)
        var closeButton: CFTypeRef?
        let closeError = AXUIElementCopyAttributeValue(window, kAXCloseButtonAttribute as CFString, &closeButton)
        if closeError == .success, let closeButton {
            AXUIElementPerformAction(closeButton as! AXUIElement, kAXPressAction as CFString)
        }
    }
}
