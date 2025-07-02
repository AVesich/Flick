//
//  AppList.swift
//  Flick
//
//  Created by Austin Vesich on 6/18/25.
//

import AppKit
import Observation

@Observable
class AllAppList: Searchable {
    
    // MARK: - Properties
    public static let shared = AllAppList()
    
    public var apps: Set<AppData> = []
    
    private var spotlightQuery: NSMetadataQuery = NSMetadataQuery()
    private var updateContinuation: CheckedContinuation<[NSMetadataItem], Never>?
    private let FILE_PREFIX = "File://"
    
    // MARK: - Initialization
    init() {
        spotlightQuery.operationQueue = .current
        spotlightQuery.searchScopes = [NSString(string: URL.applicationDirectory.path)] // searchScopes should be NSURL or NSString items
        setupAppQueryResponse()
    }
    
    deinit {
        // Necessary step; continuation leaks memory if never resumed, so do it to be safe here.
        // Double resume is prevented by setting continuation to nil after every call to resume.
        updateContinuation?.resume(returning: [])
        updateContinuation = nil
        spotlightQuery.disableUpdates()
        spotlightQuery.stop()
    }
    
    // MARK: - Public methods
    public func search(withQuery queryString: String) async -> [AppData] {
        spotlightQuery.predicate = NSPredicate(format: "(%K CONTAINS[cd] %@) AND (%K = %@)",
                                               argumentArray: [NSMetadataItemDisplayNameKey, queryString, kMDItemKind, "Application"])
        
        guard let results = await withCheckedContinuation({ continuation in
            updateContinuation = continuation
            spotlightQuery.start()
        }) as? [NSMetadataItem] else { return [] }
     
        return results.compactMap { result in
            guard let urlString = result.value(forAttribute: NSMetadataItemPathKey) as? String,
                  let url = URL(string: FILE_PREFIX + urlString) else { return nil }
            return AppData(url: url)
        }
    }
        
    // MARK: - Private app finding utils
    private func setupAppQueryResponse() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleQueryResults), name: NSNotification.Name.NSMetadataQueryDidFinishGathering, object: spotlightQuery)
    }

    @objc private func handleQueryResults() {
        let results = (spotlightQuery.results as? [NSMetadataItem]) ?? []
        updateContinuation?.resume(returning: results)
        updateContinuation = nil
    }
}
