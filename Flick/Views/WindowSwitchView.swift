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
    private var horizontalDrag: CGFloat {
        scrollState.horiScrolledPct
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
//                            EditableCell(leftEdit: hovering ? max(-horizontalDrag, 0) : 0,
//                                         rightEdit: hovering ? max(horizontalDrag, 0) : 0,
//                                         rightIcon: Image(systemName: "macwindow")) {
                                WindowCell(scrollState: scrollState,
                                           hovering: hovering,
                                           window: window)
//                            }
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
//            .onChange(of: scrollState.hasSelectedHorizontal) { _, selected in
//                if selected == true {
//                    if horizontalDrag < 0.0 { // Left drag for delete
//                        OrderedWindows.closeWindow(windowIndex: windowData[selectedIndex].2,
//                                                   pid: windowData[selectedIndex].3)
//                        scrollState.horiScrollDelta = 0.0 // Must retain value until this point so that horizontalDrag is correct
//                        Task {
//                            await scrollState.updateAppList()
//                        }
//                        scrollState.hasSelectedHorizontal = false
//                    } else {
//                        scrollState.horiScrollDelta = 0.0
//                        scrollState.hasSelectedVertical = true // Bring window to front before arranging it
//                        scrollState.isArrangingWindows = true
//                    }
//                }
//            }
        } // ScrollViewReader
        .frame(maxWidth: VisualConfigConstants.windowWidth, maxHeight: VisualConfigConstants.windowHeight)
    }
}

//#Preview {
//    WindowSwitchView(scrollState: .constant(ScrollService().scrollState))
//}
