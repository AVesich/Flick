//
//  Notification+scrollEvents.swift
//  Flick
//
//  Created by Austin Vesich on 6/19/25.
//

import Foundation

extension Notification.Name {
    static let didScrollUpNotification = Notification.Name("didScrollUpNotification")
    static let didScrollDownNotification = Notification.Name("didScrollDownNotification")
    static let didHotkeyUpNotification = Notification.Name("didHotkeyUpNotification")
    static let fakeActiveNotification = Notification.Name("fakeActiveNotification")
    static let fakeHideNotification = Notification.Name("fakeHideNotification")
    static let deletePressedNotification = Notification.Name("deletePressedNotification")
}
