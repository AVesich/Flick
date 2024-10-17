//
//  HoverService.swift
//  Mini
//
//  Created by Austin Vesich on 10/17/24.
//

// Since there seem to be no current OS-supported ways to make a window stay on top when unfocused,
// we track which apps have been minified and move them back to being on top whenever the focused app changes.
// This service handles tracking when window focus changes

import AppKit
import SwiftData

class HoverService {
    init () {
        print("Registering window switch notification")
        let notif = NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector (bringAppsToFront), name: NSWorkspace.didActivateApplicationNotification, object: nil)
    }
    
    @objc func bringAppsToFront() {
        print(NSWorkspace.shared.frontmostApplication?.localizedName)
    }
}
