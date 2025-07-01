//
//  OrderedWindows.swift
//  Mini
//
//  Created by Austin Vesich on 11/24/24.
//

import AppKit
import CoreGraphics
import ScreenCaptureKit

class ActiveWindowList: Searchable {
    
    // MARK: - Properties
    public static let shared = ActiveWindowList()
    public var appWindowCounts: [String : Int] = [:]
    public var windows: [Window] = []
    
    init() {
        Task { [weak self] in
            await self?.updateWindowList()
        }
    }
    
    // MARK: - Public Window List Operations
    public func updateWindowList() async {
        windows = await getWindowData()
    }
        
    public func search(withQuery queryString: String) -> [Window] {
        return windows.filter { window in
            return window.matches(query: queryString)
        }
    }
            
    // MARK: - Private Window List Helpers
    private func getWindowData() async -> [Window] {
        let windows = await getWindowsInZOrder()
        var appURLs = [pid_t : NSURL]()
        appWindowCounts.removeAll()
        
        for app in NSWorkspace.shared.runningApplications where app.activationPolicy == .regular {
            let nsURL = NSURL(string: app.bundleURL!.path)!
            if !AppIconCache.shared.contains(nsURL) {
                AppIconCache.shared.insert(nsURL, app.icon)
            }
            
            appURLs[app.processIdentifier] = nsURL
        }
        
        return windows.map {
            let pid = $0.owningApplication!.processID
            let bundleIdentifier = $0.owningApplication!.bundleIdentifier
            let appName = $0.owningApplication!.applicationName // Guaranteed to exist via app fillter

            appWindowCounts[bundleIdentifier] = (appWindowCounts[bundleIdentifier] ?? -1) + 1 // -1 ensures base-0 index

            return Window(appIcon: AppIconCache.shared.icon(for: appURLs[pid]!),
                          appName: appName,
                          windowTitle: $0.title ?? "Untitled",
                          windowIndex: appWindowCounts[bundleIdentifier]!,
                          appPID: pid,
                          appBundleID: bundleIdentifier)
        }
    }
        
    private func getWindowsInZOrder() async -> [SCWindow] {
        let windows = await getWindows()
        guard let windowInfo = CGWindowListCopyWindowInfo([.excludeDesktopElements, .optionOnScreenOnly], kCGNullWindowID) as? [[String: Any]] else {
            return windows
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
        let windows = (try? await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: false).windows) ?? [SCWindow]()
        return windows.filter { $0.isOpenApp && !$0.isSelf }
    }
}
