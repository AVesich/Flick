//
//  App.swift
//  Mini
//
//  Created by Austin Vesich on 10/8/24.
//

import AppKit

struct AppData: Identifiable {
    let id = UUID()
    let icon: NSImage
    let name: String
    let windowCount: Int
    var mini: Bool
}
