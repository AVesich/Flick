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
    private var horizontalDrag: CGFloat {
        scrollState.horiScrolledPct
    }
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: -4.0) {
                    ForEach(Array(scrollState.windowData.enumerated()), id:\.0) { (index, data) in
                        EditableCell(leftEdit: (selectedIndex == index && horizontalDrag < 0.0) ? -horizontalDrag : 0,
                                     rightEdit: (selectedIndex == index && horizontalDrag > 0.0) ? horizontalDrag : 0,
                                     rightIcon: Image(systemName: "macwindow")) {
                            WindowCell(index: index,
                                       appAndDesc: data,
                                       selectedIndex: selectedIndex,
                                       maxIndex: scrollState.windowData.count-1)
                        }
                        .padding(.bottom, (index == scrollState.windowData.count-1) ? 10.0 : 0.0)
                    }
                }
                .padding(10.0)
            }
            .onChange(of: selectedIndex) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .now)
                    scrollView.scrollTo(min(selectedIndex+1, scrollState.windowData.count), anchor: .bottom)
                }
            }
            .onChange(of: scrollState.hasSelectedVertical) { _, new in
                if new==true {
                    OrderedWindows.openWindow(windowIndex: scrollState.windowData[selectedIndex].2,
                                              pid: scrollState.windowData[selectedIndex].3)
                    scrollState.hasSelectedVertical = false
                }
            }
            .onChange(of: scrollState.hasSelectedHorizontal) { _, new in
                if new==true {
                    if horizontalDrag < 0.0 { // Left drag for delete
                        OrderedWindows.closeWindow(windowIndex: scrollState.windowData[selectedIndex].2,
                                                   pid: scrollState.windowData[selectedIndex].3)
                        scrollState.horiScrollDelta = 0.0 // Must retain value until this point so that horizontalDrag is correct
                        Task {
                            await scrollState.updateAppList()
                        }
                    } else {

                    }
                    scrollState.hasSelectedVertical = false
                }
            }
        } // ScrollViewReader
        .frame(maxWidth: 256.0, maxHeight: 256.0)
    }
}

#Preview {
    WindowSwitchView(scrollState: ScrollService().scrollState)
}
