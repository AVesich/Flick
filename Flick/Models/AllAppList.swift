//
//  AppList.swift
//  Flick
//
//  Created by Austin Vesich on 6/18/25.
//

import AppKit

struct AllAppList: Searchable {
    public var apps: [AppData] = [AppData]()
    private var cachedIcons: [URL: NSImage] = [URL: NSImage]()
    
    // MARK: - Public methods
    public func search(withQuery queryString: String) -> [AppData] {
        return apps.filter { app in
            return app.matches(query: queryString)
        }
    }
    
    public mutating func updateAppList() {
        let urls = getAppURLs()
        
        apps = urls.map { url in
            let icon = getAppIcon(withURL: url)
            return AppData(url: url, icon: icon)
        }
    }
    
    // MARK: - Private app finding utils
    private mutating func getAppIcon(withURL url: URL) -> NSImage {
        if cachedIcons.keys.firstIndex(of: url) == nil {
            cachedIcons[url] = NSWorkspace.shared.icon(forFile: url.path)
        }

        return cachedIcons[url] ?? .unknownIcon
    }
    
    private func getAppURLs() -> [URL] {
        let applicationsURL = URL.applicationDirectory
        let appURLs = try? FileManager.default.contentsOfDirectory(at: applicationsURL,
                                                                   includingPropertiesForKeys: [.isApplicationKey],
                                                                   options: [.skipsHiddenFiles, .skipsPackageDescendants])
        return appURLs ?? []
    }
}
