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
    private var windowData: [(NSImage, String, Int, pid_t)] {
        scrollState.windowData
    }
    private var horizontalDrag: CGFloat {
        scrollState.horiScrolledPct
    }

    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: -4.0) {
                    ForEach(Array(windowData.enumerated()), id:\.0) { (index, data) in
                        EditableCell(leftEdit: (selectedIndex == index && horizontalDrag < 0.0) ? -horizontalDrag : 0,
                                     rightEdit: (selectedIndex == index && horizontalDrag > 0.0) ? horizontalDrag : 0,
                                     rightIcon: Image(systemName: "macwindow")) {
                            WindowCell(index: index,
                                       appAndDesc: data,
                                       selectedIndex: selectedIndex,
                                       maxIndex: windowData.count-1)
                        }
                        .padding(.bottom, (index == windowData.count-1) ? 10.0 : 0.0)
                    }
                }
                .padding(10.0)
            }
            .onChange(of: selectedIndex) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .now)
                    scrollView.scrollTo(min(selectedIndex+1, windowData.count), anchor: .bottom)
                }
            }
            .onChange(of: scrollState.hasSelectedVertical) { _, new in
                if new==true {
                    OrderedWindows.openWindow(windowIndex: windowData[selectedIndex].2,
                                              pid: windowData[selectedIndex].3)
                    scrollState.hasSelectedVertical = false
                }
            }
            .onChange(of: scrollState.hasSelectedHorizontal) { _, new in
                print("changed to \(scrollState.hasSelectedHorizontal)")
                if new==true {
                    print(horizontalDrag)
                    if horizontalDrag < 0.0 { // Left drag for delete
                        OrderedWindows.closeWindow(windowIndex: windowData[selectedIndex].2,
                                                   pid: windowData[selectedIndex].3)
                        scrollState.horiScrollDelta = 0.0 // Must retain value until this point so that horizontalDrag is correct
                        Task {
                            await scrollState.updateAppList()
                        }
                    } else {
                        scrollState.horiScrollDelta = 0.0
                    }
                    scrollState.hasSelectedHorizontal = false
                }
            }
        } // ScrollViewReader
        .frame(maxWidth: 256.0, maxHeight: 256.0)
    }
}

//#Preview {
//    WindowSwitchView(scrollState: .constant(ScrollService().scrollState))
//}
