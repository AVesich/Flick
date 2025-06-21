//
//  App.swift
//  Flick
//
//  Created by Austin Vesich on 6/18/25.
//

import AppKit
import SwiftUI

struct AppData: Identifiable {
    var id = UUID()
    var name: String
    var icon: NSImage
    var url: URL
    var bundleIdentifier
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
    
    @ViewBuilder func cell(isSelected: Bool) -> any View {
        AppCell(selecting: isSelected, app: self)
    }
}
