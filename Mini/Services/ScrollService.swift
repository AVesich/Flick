//
//  HotkeyLoop.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import CoreGraphics
import AppKit
import Observation

@Observable class ScrollService {
    // MARK: - Tracking Scrolling state
    public var scrollState = ScrollTrackerState()
    public var windows = [String]()
    private var orderedWindows = OrderedWindows()
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
                                 callback: passthroughScroll,
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
                NSApp.activate(ignoringOtherApps: true)
                if let window = NSApp.windows.first {
                    window.makeKeyAndOrderFront(nil)
                }
            }
        }
        return nil // Don't pass input through any fn + z
    }
    
    return Unmanaged.passUnretained(event) // Passthrough this input, no harm in doing so
}

func fnzUp(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    if let argRef = refcon { // arg should be isTrackingScrolling
        let ptr = argRef.assumingMemoryBound(to: UnsafeMutableRawPointer.self)
        let tracker = Unmanaged<ScrollTrackerState>.fromOpaque(ptr).takeUnretainedValue()
        
        if (event.getIntegerValueField(.keyboardEventKeycode) == Keys.keyCode(for: "z") || event.flags.contains(.maskSecondaryFn))
           && tracker.isTrackingScrolling {

            tracker.isTrackingScrolling = false
            return nil // Don't pass input through
        }
    }
    return Unmanaged.passUnretained(event) // Passthrough this input, no harm in doing so
}

func passthroughScroll(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    let scroll = event.getIntegerValueField(.scrollWheelEventDeltaAxis1) // Float field still returns <int>.0
        
    // MARK: - Get the value of isTrackingScrolling as well
    if event.flags.contains(.maskSecondaryFn), let argRef = refcon { // arg should be scrollDelta
        let ptr = argRef.assumingMemoryBound(to: UnsafeMutableRawPointer.self)
        let tracker = Unmanaged<ScrollTrackerState>.fromOpaque(ptr).takeUnretainedValue()

        // Modify the property (e.g., increase the counter)
        if tracker.isTrackingScrolling {
            tracker.scrollDelta += Int(scroll)
        }
        
        return nil // Don't pass the scroll on
    }
    
    return Unmanaged.passUnretained(event)
}
