//
//  WindowSwitchView.swift
//  Mini
//
//  Created by Austin Vesich on 10/25/24.
//

import SwiftUI

struct WindowSwitchView: View {
    
    public var windowData: [(NSImage, String, Int, pid_t)]
    public var selectedIndex: Int
    public var horizontalDrag: CGFloat

    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: -4.0) {
                    ForEach(Array(windowData.enumerated()), id:\.0) { (index, appAndDesc) in
                        EditableCell(leftEdit: (-horizontalDrag)/10.0, // drag is negative by default and delta of 10 is max drag
                                     selected: selectedIndex == index) {
                            WindowCell(index: index,
                                       appAndDesc: appAndDesc,
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
        } // ScrollViewReader
        .frame(maxWidth: 256.0, maxHeight: 256.0)
    }
}

#Preview {
    WindowSwitchView(windowData: OrderedWindows().appIconsWithWindowDescriptionsAndPIDs,
                     selectedIndex: 0,
                     horizontalDrag: 0.0)
}
