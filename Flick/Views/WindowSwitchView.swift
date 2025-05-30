//
//  WindowSwitchView.swift
//  Mini
//
//  Created by Austin Vesich on 10/25/24.
//

import SwiftUI

struct WindowSwitchView: View {
    
    public var scrollState: ScrollTrackerState
    private var selectedIndex: Int {
        scrollState.vertScrolledIdx
    }
    private var windowData: [Window] {
        scrollState.windowData
    }

    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0.0) {
                    HoverCell(hovering: selectedIndex == 0) { hovering in
                        SearchTextField(text: .constant(""),
                                        hovering: hovering,
                                        placeholder: "Search")
                    }
                    .id(0)
                    .padding(.bottom, VisualConfigConstants.windowPadding)
                        
                    ForEach(Array(windowData.enumerated()), id:\.offset) { (index, window) in
                        HoverCell(hovering: (index+ScrollConfigConstants.NUM_PRE_WINDOW_SCROLL_OPTIONS == selectedIndex)) { hovering in
                            WindowCell(scrollState: scrollState,
                                       hovering: hovering,
                                       window: window)
                        }
                        .id(index+ScrollConfigConstants.NUM_PRE_WINDOW_SCROLL_OPTIONS)
                        .padding(.bottom, (index == windowData.count-1) ? 10.0 : 0.0)
                    }
                }
                .padding(VisualConfigConstants.windowPadding)
            }
            .onChange(of: selectedIndex) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .now)
                    scrollView.scrollTo(min(selectedIndex+1, windowData.count), anchor: .bottom)
                }
            }
        } // ScrollViewReader
        .frame(maxWidth: VisualConfigConstants.windowWidth, maxHeight: VisualConfigConstants.windowHeight)
    }
}

//#Preview {
//    WindowSwitchView(scrollState: .constant(ScrollService().scrollState))
//}
