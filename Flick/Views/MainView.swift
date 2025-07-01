//
//  MainView.swift
//  Mini
//
//  Created by Austin Vesich on 10/25/24.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject private var search: Search
    public var selectedIndex: Int
    private var isSearching: Bool {
        selectedIndex == 0
    }
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0.0) {
                    SearchTextField(text: $search.query, selecting: selectedIndex == 0)
                        .padding(.top, VisualConfigConstants.windowPadding)
                        .id(0)
                        .padding(.bottom, isSearching ? VisualConfigConstants.windowPadding : 4.0)
                        .animation(.bouncy(duration: VisualConfigConstants.slowAnimationDuration))
                    
                    WindowStack(selectedIndex: selectedIndex)
                        .padding(.bottom, VisualConfigConstants.windowPadding)
                }
                .padding(.horizontal, VisualConfigConstants.windowPadding)
            }
            .onShowApp {
                scrollView.scrollTo(0)
            }
            .onChange(of: selectedIndex) {
                withAnimation(.easeInOut(duration: VisualConfigConstants.slowAnimationDuration)) {
                    NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .now)
                    scrollView.scrollTo(min(selectedIndex+1, search.results.count), anchor: .bottom)
                }
            }
        } // ScrollViewReader
        .frame(maxWidth: VisualConfigConstants.windowWidth, maxHeight: VisualConfigConstants.windowHeight)
        .onKeyPress(.upArrow) {
            NotificationCenter.default.post(name: .didScrollUpNotification, object: nil)
            return .handled
        }
        .onKeyPress(.downArrow) {
            NotificationCenter.default.post(name: .didScrollDownNotification, object: nil)
            return .handled
        }
    }
}

//#Preview {
//    WindowSwitchView(scrollState: ScrollService().scrollState)
//}
