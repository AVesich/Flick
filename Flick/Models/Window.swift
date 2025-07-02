//
//  Window.swift
//  Flick
//
//  Created by Austin Vesich on 5/30/25.
//

import AppKit
import SwiftUI

struct Window: Identifiable {
    var id = UUID()

    var appIcon: NSImage
    var appName: String
    var windowTitle: String
    var windowIndex: Int
    var appPID: pid_t
    var appBundleID: String
    var appWindowsLeft: Int? {
        return ActiveWindowList.shared.appWindowCounts[appBundleID] ?? 1
    }
}

extension Window: Equatable {
    static func == (_ lhs: Window, _ rhs: Window) -> Bool {
        return lhs.appPID == rhs.appPID && lhs.windowTitle == rhs.windowTitle
    }
}

extension Window: SearchableItem {
    public func matches(query queryString: String) -> Bool {
        return appNameMatches(queryString) || windowTitleMatches(queryString)
    }
    
    private func appNameMatches(_ queryString: String) -> Bool {
        return appName.lowercased().starts(with: queryString.lowercased())
    }
    
    private func windowTitleMatches(_ queryString: String) -> Bool {
        return windowTitle.lowercased().contains(queryString.lowercased())
    }
    
    @ViewBuilder func cell(index: Int, isSelected: Bool) -> any View {
        WindowCell(index: index, selecting: isSelected, window: self)
    }
}
