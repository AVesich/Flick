//
//  WindowInfo.swift
//  Mini
//
//  Created by Austin Vesich on 10/8/24.
//

import AppKit
import SwiftData

class WindowManager {
    
    public static let shared = WindowManager()
    
    var errorMinifying: Bool = false
    var openApps: [AppData] {
        let dockApps = NSWorkspace.shared.runningApplications.filter {
            $0.activationPolicy == .regular
        }
        
        let appData = dockApps.map {
            return AppData(icon: $0.icon ?? NSImage(systemSymbolName: "questionmark", accessibilityDescription: nil)!,
                           name: $0.localizedName ?? "No name found",
                           mini: false)
        }
        
        return appData
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
            
            try callAppleScript(miniScriptURL, withMainFuncName: "minify", andArgs: [appName])
        } catch {
            errorMinifying = false
        }
    }
}
