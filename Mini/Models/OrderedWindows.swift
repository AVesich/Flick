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
    public var appIconsWithWindowDescriptions = [(NSImage, String)]()
    
    init() {
        Task {
            let windowsToApps = await availableWindowsForApps() // window id:app name
            let appsToIcons = availableAppIcons() // app name:app icon
            let (orderedWindows, windowsToDescriptions) = availableWindowIDsWithDescriptions() // ordered window ids (f-to-b), window id:window name
            let windowIDs = orderedWindows.filter { windowsToApps.keys.contains($0) }
            
            appIconsWithWindowDescriptions = windowIDs.map {
                ((appsToIcons[windowsToApps[$0]!] ?? NSImage(systemSymbolName: "questionmark", accessibilityDescription: nil))!, windowsToDescriptions[$0]!)
            }
        }
    }
        
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


    private func availableWindowIDsWithDescriptions() -> ([CGWindowID], [CGWindowID: String]) { // ordered window ids (f-to-b), window id:window name
        let windowOptions = CGWindowListOption(arrayLiteral: .excludeDesktopElements, .optionOnScreenOnly)
        let windowListInfo = CGWindowListCopyWindowInfo(windowOptions, CGWindowID(0))
        let windows = windowListInfo as! [[CFString: AnyObject]]
        let filtered = windows.filter { ($0[kCGWindowLayer] as! Int) == 0 }
        
        return (
            filtered.map { $0[kCGWindowNumber] as! CGWindowID } ,
            Dictionary(uniqueKeysWithValues:
                filtered.map {
                    ($0[kCGWindowNumber] as! CGWindowID, $0[kCGWindowName] as! String)
                }
            )
        )
    }
}
