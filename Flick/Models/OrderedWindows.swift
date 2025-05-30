//
//  OrderedWindows.swift
//  Mini
//
//  Created by Austin Vesich on 11/24/24.
//

import AppKit
import CoreGraphics
import ScreenCaptureKit
import Observation

@Observable class OrderedWindows {
    public var appIconsWithWindowDescriptionsAndPIDs = [Window]()
    
    init() {
        Task {
            await updateAppList()
        }
    }
    
    // MARK: - Updating Window List
    public func updateAppList() async {        
        let windowsToApps = await availableWindowsForApps() // window id:app name
        let appsToIcons = availableAppIcons() // app name:app icon
        let (orderedWindows, windowsToDescriptionsAndPIDs) = availableWindowIDsWithDescriptions() // ordered window ids (f-to-b), window id:(window name, window index, app pid)
        let windowIDs = orderedWindows.filter { windowsToApps.keys.contains($0) }
            
        appIconsWithWindowDescriptionsAndPIDs = windowIDs.map {
            Window(appIcon: (appsToIcons[windowsToApps[$0]!] ?? NSImage(systemSymbolName: "questionmark", accessibilityDescription: nil))!,
                   windowTitle: windowsToDescriptionsAndPIDs[$0]!.0,
                   windowNumber: windowsToDescriptionsAndPIDs[$0]!.1,
                   appPID: windowsToDescriptionsAndPIDs[$0]!.2)
        }
    }
        
    // MARK: - Private Window List Helpers
    private func availableWindowsForApps() async -> [CGWindowID:String] { // window id:app name
        let windows = (try? await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: true))?.windows ?? [SCWindow]()
        
        // Remove windows that don't have an associated .app bundle
        let filteredWindows = windows.filter { $0.owningApplication != nil && $0.owningApplication?.applicationName != "" }
        // Remove this app's window from the list
        .filter { $0.owningApplication?.bundleIdentifier != Bundle.main.bundleIdentifier }
        
        return Dictionary(uniqueKeysWithValues:
            filteredWindows.map {
                ($0.windowID, $0.owningApplication!.applicationName) // Owning app can't be nil because it would be filtered out above
            }
        )
    }
    
    private func availableAppIcons() -> [String: NSImage?] { // app name:app icon
        var results = [String: NSImage?]()
        
        // Iterating instead of using map{ } avoids errors when running into duplicates
        for app in NSWorkspace.shared.runningApplications where app.localizedName != nil {
            results[app.localizedName!] = app.icon
        }
        return results
    }


    private func availableWindowIDsWithDescriptions() -> ([CGWindowID], [CGWindowID: (String, Int, pid_t)]) { // ordered window ids (f-to-b), window id:(window name, window index, app pid)
        let windowOptions = CGWindowListOption(arrayLiteral: .excludeDesktopElements, .optionOnScreenOnly)
        let windowListInfo = CGWindowListCopyWindowInfo(windowOptions, CGWindowID(0))
        let windows = windowListInfo as! [[CFString: AnyObject]]
        let filtered = windows.filter { ($0[kCGWindowLayer] as! Int) == 0 }
        
        var pids = [pid_t:Int]()
        return (
            filtered.map { $0[kCGWindowNumber] as! CGWindowID } ,
            Dictionary(uniqueKeysWithValues:
                filtered.map {
                    let windowIndex = pids[$0[kCGWindowOwnerPID] as! pid_t] ?? 0
                    pids[$0[kCGWindowOwnerPID] as! pid_t] = windowIndex + 1
                    return ($0[kCGWindowNumber] as! CGWindowID, ($0[kCGWindowName] as! String, windowIndex, $0[kCGWindowOwnerPID] as! pid_t))
                }
            )
        )
    }
        
    // MARK: - Static Window Helpers (Open/Close)
    static func openWindow(windowIndex index: Int, pid: pid_t) {
        let element = AXUIElementCreateApplication(pid)
        var windows: CFArray?
        let error = AXUIElementCopyAttributeValues(element, kAXWindowsAttribute as CFString, 0, 99999, &windows)
        
        if error == .success, let windows, CFArrayGetCount(windows) > index {
            let window = unsafeBitCast(CFArrayGetValueAtIndex(windows, index), to: AXUIElement.self)
            AXUIElementPerformAction(window, kAXRaiseAction as CFString)
        }
    }

    static func closeWindow(windowIndex index: Int, pid: pid_t) {
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

}
