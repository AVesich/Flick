//
//  WindowInfo.swift
//  Mini
//
//  Created by Austin Vesich on 10/9/24.
//

import SwiftData
import Foundation

@Model class WindowInfo {
    @Attribute(.unique) var appURL: String! // The url for the application is used to identify the data for the app
    private(set) var origin: CGPoint!
    private(set) var size: CGSize!
    
    init(appURL: String, origin: CGPoint, size: CGSize) {
        self.appURL = appURL
        self.origin = origin
        self.size = size
    }
}
