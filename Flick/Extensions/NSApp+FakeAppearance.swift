//
//  NSApp+FakeAppearance.swift
//  Flick
//
//  Created by Austin Vesich on 6/20/25.
//

import AppKit

extension NSApplication {
    func fakeHide() {
        NotificationCenter.default.post(name: .fakeHideNotification, object: nil)
    }
    
    func fakeActivate() {
        NotificationCenter.default.post(name: .fakeActiveNotification, object: nil)
    }
}
