//
//  WindowAppearance.swift
//  Flick
//
//  Created by Austin Vesich on 6/8/25.
//

import AppKit

final class WindowAppearance {
    
    private static var launchConfig: NSWorkspace.OpenConfiguration {
        let config = NSWorkspace.OpenConfiguration()
        
        config.activates = true

        return config
    }

    static func openApp(_ app: AppData) {
        NSWorkspace.shared.openApplication(at: app.url, configuration: WindowAppearance.launchConfig)
    }
    
    static func openWindow(_ window: Window) {
        let app = AXUIElementCreateApplication(window.appPID)
        var windows: CFArray?
        let result = AXUIElementCopyAttributeValues(app, kAXWindowsAttribute as CFString, 0, 99999, &windows)
        
        guard result == .success, let windows = windows as? [AXUIElement], windows.count > window.windowIndex else {
            return
        }
        AXUIElementPerformAction(windows[window.windowIndex], kAXRaiseAction as CFString)
    }

    static func closeWindow(_ window: Window) {
        Task { @MainActor in
            let killOnCloseList = BlockedAppList.shared.getBlockedApps()
            
            if window.appWindowsLeft == 1 && killOnCloseList.contains(where: { $0.bundleID == window.appBundleID }) {
                closeApplication(pid: window.appPID)
                return
            } else {
                clickCloseOnWindow(windowIndex: window.windowIndex, pid: window.appPID)
            }
        }
    }
    
    private static func clickCloseOnWindow(windowIndex index: Int, pid: pid_t) {
        let app = AXUIElementCreateApplication(pid)
        var windows: CFArray?
        let result = AXUIElementCopyAttributeValues(app, kAXWindowsAttribute as CFString, 0, 99999, &windows)
          
        guard result == .success, let windows = windows as? [AXUIElement], windows.count > index else {
            return
        }
        let window = windows[index]
                                
        var closeButton: CFTypeRef?
        let closeResult = AXUIElementCopyAttributeValue(window, kAXCloseButtonAttribute as CFString, &closeButton)
        guard closeResult == .success, let closeButton else {
            return
        }
        AXUIElementPerformAction(closeButton as! AXUIElement, kAXPressAction as CFString)
    }
    
    private static func closeApplication(pid: pid_t) {
        kill(pid, SIGTERM)
    }
}
