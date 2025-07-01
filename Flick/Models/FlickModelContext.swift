//
//  FlickModelContext.swift
//  Flick
//
//  Created by Austin Vesich on 6/22/25.
//

import SwiftData

struct FlickDataModel {
    
    // MARK: - Singleton
    public static let shared = FlickDataModel()
    public var modelContext: ModelContext!
    public var modelContainer: ModelContainer!
    
    init() {
        do {
            let modelConfig = ModelConfiguration(for: AppData.self, isStoredInMemoryOnly: false)
            let container = try ModelContainer(for: AppData.self, configurations: modelConfig)
            
            modelContainer = container
            modelContext = ModelContext(modelContainer)
        } catch {
            // TODO: Replace with warning
            fatalError("Failed to init model container")
        }
    }
    
}
