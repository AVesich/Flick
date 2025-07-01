//
//  SCWindow+isOpenApp.swift
//  Flick
//
//  Created by Austin Vesich on 5/31/25.
//

import ScreenCaptureKit

extension SCWindow {
    var isOpenApp: Bool {
        owningApplication != nil &&
        owningApplication?.applicationName.isEmpty == false &&
        windowLayer == .zero &&
        isActive
    }
    
    var isSelf: Bool {
        owningApplication?.bundleIdentifier == Bundle.main.bundleIdentifier
    }
}
