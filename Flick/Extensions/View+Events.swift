//
//  View+Events.swift
//  Flick
//
//  Created by Austin Vesich on 6/20/25.
//

import SwiftUI

extension View {
    func onShowApp(action: @escaping () -> Void) -> some View {
        self.onReceive(NotificationCenter.default.publisher(for: .fakeActiveNotification)) { _ in
            action()
        }
    }
    
    func onHideApp(action: @escaping () -> Void) -> some View {
        self.onReceive(NotificationCenter.default.publisher(for: .fakeHideNotification)) { _ in
            action()
        }
    }
    
    func onHotkeyUp(action: @escaping () -> Void) -> some View {
        self.onReceive(NotificationCenter.default.publisher(for: .didHotkeyUpNotification)) { _ in
            action()
        }
    }
}
