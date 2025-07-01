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
    private var started: Bool = false
    
    // MARK: - Initialization
    init() {
        if started {
            return
        }
        started = true
        
        if let keyDownEvent = registerEvent(withBitmask: 1 << CGEventType.keyDown.rawValue, callback: hotkeyDown),
           let keyUpEvent = registerEvent(withBitmask: 1 << CGEventType.keyUp.rawValue, callback: hotkeyUp),
           let scrollEvent = registerEvent(withBitmask: 1 << CGEventType.scrollWheel.rawValue, callback: scrollHandler) {
            Task { [weak self] in
                self?.startRunLoopForEvent(keyDownEvent)
            }
            Task { [weak self] in
                self?.startRunLoopForEvent(keyUpEvent)
            }
            Task { [weak self] in
                self?.startRunLoopForEvent(scrollEvent)
            }
        } else {
            // TODO: - Show oops dialog
        }
    }
    
    // MARK: - Event registration
    private func registerEvent(withBitmask bitmask: Int, callback: CGEventTapCallBack) -> CFMachPort? {
        let mask = CGEventMask(bitmask)
        return CGEvent.tapCreate(tap: .cgSessionEventTap,
                                 place: .tailAppendEventTap,
                                 options: .defaultTap,
                                 eventsOfInterest: mask,
                                 callback: callback,
                                 userInfo: nil)
    }
    
    // MARK: - Event running
    // For context, CFRunLoop is in charge of control & input dispatch for a task
    private func startRunLoopForEvent(_ event: CFMachPort) {
        let runLoopSource = CFMachPortCreateRunLoopSource(nil, event, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: event, enable: true)
    }
}

// MARK: - Event handling
let TAB_KEYCODE = 48
func hotkeyDown(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    if ScrollConfigConstants.SHORTCUT.isPressed(event: event) {
        if !ScrollTrackingSharedState.shared.hotkeyDown {
            ScrollTrackingSharedState.shared.hotkeyDown = true
            DispatchQueue.main.async {
                Task {
                    NSApp.activate(ignoringOtherApps: true)
                    NSApp.fakeActivate()
                }
            }
        }
        
        return nil
    }
    
    return Unmanaged.passUnretained(event) // Passthrough this input, no harm in doing so
}

func hotkeyUp(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    // NOTE: The event only gets emitted if the app is visible to prevent "selecting windows from the grave"
    // However, hotkeyDown is always updated to prevent a selection by click from keeping hotkeyDown == true and thus, preventing the app from reopening.
    if (event.getIntegerValueField(.keyboardEventKeycode) == TAB_KEYCODE) {
        ScrollTrackingSharedState.shared.hotkeyDown = false
        if ScrollTrackingSharedState.shared.isVisible {
            NotificationCenter.default.post(name: .didHotkeyUpNotification, object: nil) // Let the app listen and then decide if it cares based on search status
        }
        return nil // Don't pass input through
    }
    
    return Unmanaged.passUnretained(event) // Passthrough this input, no harm in doing so
}

// All horizontal scroll values here are negative because a pan left triggers delete and also produces a negative value
func scrollHandler(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    if ScrollTrackingSharedState.shared.isVisible {
        let vertDelta = event.getIntegerValueField(.scrollWheelEventDeltaAxis1)
        ScrollTrackingSharedState.shared.scrollDelta += Int(vertDelta)
        return nil
    }
    
    return Unmanaged.passUnretained(event)
}
