//
//  HotkeyLoop.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import CoreGraphics
import AppKit
import CoreHaptics

class HotkeyService: ObservableObject {
    public func start() {
        if let keyDownEvent = registerKeyDownEvent() {
            print("setting up hotkey event")
            startRunLoopForEvent(keyDownEvent)
        } else {
            // TODO: - Show oops dialog
            fatalError("Error setting up hotkey event")
        }
    }
        
    private func registerKeyDownEvent() -> CFMachPort? {
        print("registering hotkey event")
        let buttonDownBitMask = 1 << CGEventType.keyDown.rawValue
        let buttonDownMask = CGEventMask(buttonDownBitMask)
        return CGEvent.tapCreate(tap: .cgSessionEventTap,
                                 place: .tailAppendEventTap,
                                 options: .defaultTap,
                                 eventsOfInterest: buttonDownMask,
                                 callback: handleButtonDownEvents,
                                 userInfo: nil)
    }
                
    // For context, CFRunLoop is in charge of control & input dispatch for a task
    private func startRunLoopForEvent(_ event: CFMachPort) {
        print("starting hotkey event loop")
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, event, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: event, enable: true)
        CFRunLoopRun()
    }
    
}

func handleButtonDownEvents(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    let mPressed = event.getIntegerValueField(.keyboardEventKeycode) == Keys.keyCode(for: "m")
    
    let optionPressed = event.flags.contains(.maskAlternate)
    let controlPressed = event.flags.contains(.maskControl)
    if mPressed && optionPressed {
        NSApp.activate(ignoringOtherApps: true)
        if let window = NSApp.windows.first {
            window.makeKeyAndOrderFront(nil)
        }
        return nil
    } else if mPressed && controlPressed && !NSApp.isActive { // We will only minify apps that aren't us
//        WindowManager.shared.minifyCurrentApp()
        return nil
    }
    
    return Unmanaged.passUnretained(event)
}
