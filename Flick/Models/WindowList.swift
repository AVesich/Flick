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

@Observable class WindowList {
    public var appIconsWithWindowDescriptionsAndPIDs = [Window]()
    public static var appIcons: [String: NSImage?] = [String: NSImage?]()
    
    init() {
        Task {
            await updateAppList()
        }
    }		
    
    // MARK: - Updating Window List
    public func updateAppList() async {
        appIconsWithWindowDescriptionsAndPIDs = await getWindowData()
    }
    
    public static func updateAppIcons() {
        appIcons = [String: NSImage?]()
        
        // Iterating instead of using map{ } avoids errors when running into duplicates
        for app in NSWorkspace.shared.runningApplications where app.localizedName != nil {
            appIcons[app.localizedName!] = app.icon
        }
    }
        
    // MARK: - Private Window List Helpers
    private func getWindowData() async -> [Window] {
        let windows = await getWindowsInZOrder()
        
        WindowList.updateAppIcons()
                                
        var pidCounts = [pid_t : Int]()
        
        return windows.map {
            let pid = $0.owningApplication!.processID
            pidCounts[pid] = pidCounts[pid] == nil ? 0 : pidCounts[pid]! + 1
            return Window(appIcon: .appIcon(withName: $0.owningApplication!.applicationName),
                          windowTitle: $0.title ?? "Untitled",
                          windowNumber: pidCounts[pid]!,
                          appPID: pid		   )
        }
    }
    
    private func getWindowsInZOrder() async -> [SCWindow] {
        var windows = await getWindows()
        guard let windowInfo = CGWindowListCopyWindowInfo([.excludeDesktopElements, .optionOnScreenOnly], kCGNullWindowID) as? [[String: Any]] else {
            return [SCWindow]()
        }
        
        return windowInfo.compactMap { info in
            if let windowID = info[kCGWindowNumber as String] as? UInt32,
               let window = windows.first(where: { $0.windowID == windowID }) {
                return window
            } else {
                return nil
            }
        }
    }
    
    private func getWindows() async -> [SCWindow] {
        do {
            let windows = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: false).windows
            return windows.filter { $0.isOpenApp && !$0.isSelf }
        } catch {
            return [SCWindow]()
        }
    }
}
