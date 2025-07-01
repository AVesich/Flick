//
//  Search.swift
//  Flick
//
//  Created by Austin Vesich on 6/19/25.
//

import Foundation

class Search: ObservableObject {
    // MARK: - Private Properties
    public var allAppList: AllAppList!
    public var activeWindowList: ActiveWindowList!
    private var isRefreshing: Bool = false
    
    // MARK: - Public Properties
    @Published public var query: String = "" {
        didSet {
            guard oldValue != query else { return }
            updateResults()
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
    private func searchAllLists(withQuery queryString: String) -> [any SearchableItem & Identifiable] {
        let openedBundleIDs = Set<String>(activeWindowList.appWindowCounts.keys)
        let openableApps = allAppList.search(withQuery: queryString).filter { app in
            !openedBundleIDs.contains(app.bundleID) && app.bundleID != Bundle.main.bundleIdentifier!
        }
        
        return activeWindowList.search(withQuery: queryString) + openableApps
    }
    
    public func refresh() async {
        guard !isRefreshing else { return }
        isRefreshing = true
        
        await activeWindowList.updateWindowList()
        allAppList.updateAppList()
        updateResults()
        
        isRefreshing = false
    }
    
    private func updateResults() {
        DispatchQueue.main.async { [weak self] in
            guard self != nil else { return }
            
            guard !self!.query.isEmpty else {
                print("regular")
                self!.results = self!.activeWindowList.windows
                return
            }
            
            print("search")
            self!.results = self!.searchAllLists(withQuery: self!.query)
        }
    }
}
