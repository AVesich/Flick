//
//  AppList.swift
//  Flick
//
//  Created by Austin Vesich on 6/18/25.
//

import AppKit

struct AllAppList: Searchable {
    
    // MARK: - Properties
    public static let shared = AllAppList()
    
    public var apps: Set<AppData> = []
    
    // MARK: - Public methods
    public func search(withQuery queryString: String) -> [AppData] {
        return apps.filter { app in
            return app.matches(query: queryString)
        }
    }
    
    public mutating func updateAppList() {
        for url in getAppURLs() {
            guard !apps.contains(where: { app in app.url == url }) else { continue }
            apps.insert(AppData(url: url))
        }
    }
    
    // MARK: - Private app finding utils    
    private func getAppURLs() -> [URL] {
        let applicationsURL = URL.applicationDirectory
        let appURLs = try? FileManager.default.contentsOfDirectory(at: applicationsURL,
                                                                   includingPropertiesForKeys: [.isApplicationKey],
                                                                   options: [.skipsHiddenFiles, .skipsPackageDescendants])
        return appURLs ?? []
    }
}
