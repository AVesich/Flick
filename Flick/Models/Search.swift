//
//  Search.swift
//  Flick
//
//  Created by Austin Vesich on 6/19/25.
//

import Foundation

@MainActor
class Search: ObservableObject {
    // MARK: - Private Properties
    public var allAppList: AllAppList!
    public var activeWindowList: ActiveWindowList!
    private var isRefreshing: Bool = false
    
    // MARK: - Public Properties
    @Published public var query: String = "" {
        didSet {
            guard oldValue != query else { return }
//            if oldValue.isEmpty { // We are now searching for something, so update the internal app list
//                Task { [weak self] in
//                    await self?.allAppList.updateAppList()
//                }
//            }
            Task { [weak self] in
                await self?.updateResults()
            }
        }
    }
    @Published public var results: [any SearchableItem & Identifiable] = []
    public var allApps: [AppData] {
        return allAppList.apps.filter { app in
            app.bundleID != Bundle.main.bundleIdentifier!
        }
    }
    
    // MARK: - Initailization
    init(appList: AllAppList!, windowList: ActiveWindowList!) {
        self.allAppList = appList
        self.activeWindowList = windowList
    }
    
    // MARK: - Searching
    private func searchAllLists(withQuery queryString: String) async -> [any SearchableItem & Identifiable] {
        let openedBundleIDs = Set<String>(activeWindowList.appWindowCounts.keys)
        let openableApps = await allAppList.search(withQuery: queryString).filter { app in
            !openedBundleIDs.contains(app.bundleID) && app.bundleID != Bundle.main.bundleIdentifier!
        }
        
        return await activeWindowList.search(withQuery: queryString) + openableApps
    }
    
    public func refreshWindowList() async {
        guard !isRefreshing else { return }
        isRefreshing = true
        
        await activeWindowList.updateWindowList()
        await updateResults()
        
        isRefreshing = false
    }
    
    private func updateResults() async {
        guard !query.isEmpty else {
            results = activeWindowList.windows
            return
        }
        
        results = await searchAllLists(withQuery: query)
    }
}
