//
//  AppIconCache.swift
//  Flick
//
//  Created by Austin Vesich on 6/29/25.
//

import AppKit

struct AppIconCache {
    
    // MARK: - Singleton
    public static let shared: AppIconCache = AppIconCache()
    
    // MARK: - Properties
    private let cache: NSCache<NSURL, NSImage>
    
    // MARK: - Initializatino
    init() {
        cache = NSCache<NSURL, NSImage>()
        cache.name = "com.flick.appicons.cache"
    }
    
    // MARK: - Methods
    public func insert(_ url: NSURL, _ image: NSImage?) {
        cache.setObject(image ?? .unknownIcon, forKey: url)
    }
    
    public func icon(for url: NSURL) -> NSImage {
        cache.object(forKey: url) ?? .unknownIcon
    }
    
    public func contains(_ url: NSURL) -> Bool {
        cache.object(forKey: url) != nil
    }
}
