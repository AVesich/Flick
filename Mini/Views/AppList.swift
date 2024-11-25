//
//  SelectableScrollView.swift
//  Mini
//
//  Created by Austin Vesich on 10/8/24.
//

import SwiftUI

struct AppList: View {
    
    @ObservedObject var windowManager: WindowManager
    @State private var selectedRow: Int? = nil
    @State private var searchQuery = ""
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            TextField(text: $searchQuery, prompt: Text("Find an app...")) {}
                .textFieldStyle(.plain)
                .padding(.horizontal, 16.0)
                .padding(.vertical, 10.0)
                .background {
                    RoundedRectangle(cornerRadius: 8.0)
                        .fill(.white.opacity(0.1))
                }
            .font(.system(size: 14.0).weight(.semibold))
            LazyVStack(spacing: 4.0) {
//                ForEach(Array(windowManager.availableWindows.enumerated()), id: \.offset) { (offset, (window, icon)) in
//                    Text("\(window.owningApplication?.applicationName) \(window.windowID)")
////                    AppCell(app: app, index: offset)
//                }
            }
            .padding(.bottom, 16.0)
        }
    }
}
