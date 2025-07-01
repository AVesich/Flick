//
//  BlockedAppList.swift
//  Flick
//
//  Created by Austin Vesich on 6/22/25.
//

import SwiftData

@MainActor // Required for model context actions
struct BlockedAppList {
    
    // MARK: - Properties
    public static let shared = BlockedAppList(modelContext: FlickDataModel.shared.modelContext)
    
    public var modelContext: ModelContext!
    
    // MARK: - Initialization
    init(modelContext: ModelContext!) {
        self.modelContext = modelContext
    }
    
    // MARK: - Methods
    public func blockApp(_ app: AppData) {
        modelContext.insert(app)
        try? modelContext.save()
    }
    
    public func unblockApp(_ app: AppData) {
        modelContext.delete(app)
        try? modelContext.save()
    }
    
    public func getBlockedApps() -> [AppData] {
        let fetchDescriptor = FetchDescriptor<AppData>()
        let blockedApps = try? modelContext.fetch(fetchDescriptor)
        return blockedApps ?? []
    }
}
