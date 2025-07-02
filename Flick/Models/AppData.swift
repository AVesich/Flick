//
//  AppData.swift
//  Flick
//
//  Created by Austin Vesich on 6/18/25.
//

import AppKit
import SwiftUI
import SwiftData

// MARK: - AppData
@Model
final class AppData: Identifiable {
    var id: String {
        bundleID
    }
    
    var name: String
    var icon: NSImage {
        let nsURL = NSURL(string: url.path)!
        if !AppIconCache.shared.contains(nsURL) {
            AppIconCache.shared.insert(nsURL, NSWorkspace.shared.icon(forFile: url.path))
        }

        return AppIconCache.shared.icon(for: nsURL)
    }
    var url: URL
    var bundleID: String
    
    init(url appURL: URL) {
        let path = appURL.relativePath
        let dotAppName = path.components(separatedBy: "/").last
        name = dotAppName?.components(separatedBy: ".").first ?? "Untitled"
        url = appURL
        bundleID = Bundle(url: appURL)?.bundleIdentifier ?? "unknown"
    }
}

extension AppData: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}

extension AppData: Equatable {
    static func == (lhs: AppData, rhs: AppData) -> Bool {
        lhs.id == rhs.id
    }
}

extension AppData: SearchableItem {
    public func matches(query queryString: String) -> Bool {
        return nameMatches(queryString) || nameContains(queryString)
    }
    
    private func nameMatches(_ queryString: String) -> Bool {
        return name.lowercased().starts(with: queryString.lowercased())
    }
    
    private func nameContains(_ queryString: String) -> Bool {
        return name.lowercased().contains(queryString.lowercased())
    }
    
    @ViewBuilder func cell(index: Int, isSelected: Bool) -> any View {
        AppCell(selecting: isSelected, app: self)
    }
}
