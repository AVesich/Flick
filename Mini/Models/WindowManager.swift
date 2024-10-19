//
//  WindowInfo.swift
//  Mini
//
//  Created by Austin Vesich on 10/8/24.
//

import AppKit
import SwiftData
import Combine
import CoreGraphics
import ScreenCaptureKit

@MainActor
class WindowManager: ObservableObject {
    
    private var minifiedApps = Set<String>()
    
    @Published var errorMinifying: Bool = false
    @Published private(set) var availableWindows = [SCWindow]()
    
    func beginUpdating() async {
        await updateWindowList()
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in
            Task {
                await self?.updateWindowList()
            }
        }
        .fire()
    }
    
    func updateWindowList() async {
        do {
            let content = try await SCShareableContent.excludingDesktopWindows(false,
                                                                               onScreenWindowsOnly: true)
            availableWindows = filterWindows(content.windows)
        } catch {
            print("Failed to get the shareable content: \(error.localizedDescription)")
        }
    }
    
    // We only want to give the user access to dock-launched windows
    private func validWindows() -> Set<CGWindowID> {
        let windowOptions = CGWindowListOption(arrayLiteral: .excludeDesktopElements, .optionOnScreenOnly)
        let windowListInfo = CGWindowListCopyWindowInfo(windowOptions, CGWindowID(0))
        let windows = windowListInfo as! [[CFString: AnyObject]]
        let filtered = windows.filter { ($0[kCGWindowLayer] as! Int) == 0 }
        let windowIDs = Set<CGWindowID>(filtered.map { $0[kCGWindowNumber] as! CGWindowID })
        return windowIDs
    }
    
    private func filterWindows(_ windows: [SCWindow]) -> [SCWindow] {
        let validWindows = validWindows()
        
        return windows
        // Sort the windows by app name.
            .sorted { $0.owningApplication?.applicationName ?? "" < $1.owningApplication?.applicationName ?? "" }
        // Remove windows that don't have an associated .app bundle.
            .filter { $0.owningApplication != nil && $0.owningApplication?.applicationName != "" }
        // Remove this app's window from the list.
            .filter { $0.owningApplication?.bundleIdentifier != Bundle.main.bundleIdentifier }
        // Remove windows that aren't in the list of windows we should show (We only show windows belonging to apps in the dock)
            .filter { validWindows.contains($0.windowID) }
    }
    
    func minifyCurrentApp() {
        guard let activeAppName = NSWorkspace.shared.frontmostApplication?.localizedName else {
            return
        }
        minifyApp(withName: activeAppName)
    }
    
    func minifyApp(withName appName: String) {
        do {
            let miniScriptURL = Bundle.main.url(forResource: "mini", withExtension: "scpt")!
            
            try callAppleScript(miniScriptURL,
                                withMainFuncName: "minify",
                                andArgs: [NSAppleEventDescriptor(string: appName),
                                          NSAppleEventDescriptor(int32: 1)]) // Minify the first/main window of an app by default
            minifiedApps.insert(appName)
        } catch {
            errorMinifying = false
        }
    }
    
    @objc func makeAppsFrontmost() {
        for app in minifiedApps {
            do {
                let bringToFrontScriptURL = Bundle.main.url(forResource: "front", withExtension: "scpt")!
                
                try callAppleScript(bringToFrontScriptURL,
                                    withMainFuncName: "frontmost",
                                    andArgs: [NSAppleEventDescriptor(string: app),
                                              NSAppleEventDescriptor(int32: 1)]) // Minify the first/main window of an app by default
            } catch {
                errorMinifying = false
            }
        }
    }
}
