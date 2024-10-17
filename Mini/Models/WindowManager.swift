//
//  WindowInfo.swift
//  Mini
//
//  Created by Austin Vesich on 10/8/24.
//

import AppKit
import SwiftData
import CoreGraphics

class WindowManager {
    
    public static let shared = WindowManager()
    
    var errorMinifying: Bool = false
    var openApps: [AppData] {
        let dockApps = NSWorkspace.shared.runningApplications.filter {
            $0.activationPolicy == .regular
        }
        
        let counts = windowCounts
        let appData = dockApps.map {
            return AppData(icon: $0.icon ?? NSImage(systemSymbolName: "questionmark", accessibilityDescription: nil)!,
                           name: $0.localizedName ?? "No name found",
                           windowCount: counts[$0.localizedName ?? ""] ?? 1,
                           mini: false)
        }
        
        return appData
    }
    private var windowCounts: [String : Int] {
        let windowOptions = CGWindowListOption(arrayLiteral: .excludeDesktopElements, .optionOnScreenOnly)
        let windowListInfo = CGWindowListCopyWindowInfo(windowOptions, CGWindowID(0))
        let windows = windowListInfo as! [[CFString: AnyObject]]
        let filtered = windows.filter { ($0[kCGWindowLayer] as! Int) == 0 }
        
        var windowCounts = [String : Int]()
        for window in filtered {
            windowCounts[window[kCGWindowOwnerName] as! String] = (windowCounts[window[kCGWindowOwnerName] as! String] ?? 0) + 1
        }
        return windowCounts
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
        } catch {
            errorMinifying = false
        }
    }
}
