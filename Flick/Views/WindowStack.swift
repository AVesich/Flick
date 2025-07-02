//
//  WindowListView.swift
//  Flick
//
//  Created by Austin Vesich on 6/20/25.
//

import SwiftUI

struct WindowStack: View {
    
    @EnvironmentObject private var search: Search
    public var selectedIndex: Int
    private var isSearching: Bool {
        selectedIndex == 0
    }

    var body: some View {
        VStack(spacing: 0.0) {
            ForEach(Array(search.results.enumerated()), id:\.offset) { (index, searchItem) in
                let cellIndex = index + ScrollConfigConstants.NUM_PRE_WINDOW_SCROLL_OPTIONS
                return AnyView(searchItem.cell(index: index, isSelected: selectedIndex == cellIndex))
                            .id(cellIndex)
                            .padding(.bottom, (index == search.results.count-1) ? 10.0 : 0.0)
                            .animation(.bouncy(duration: 0.27, extraBounce: 0.3).delay(0.025 * Double(index)), value: isSearching)
            }
        }
    }
}

#Preview {
    WindowStack(selectedIndex: 0)
}
