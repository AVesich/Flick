//
//  WindowSwitchView.swift
//  Mini
//
//  Created by Austin Vesich on 10/25/24.
//

import SwiftUI

struct WindowSwitchView: View {
    
    @FocusState private var permAppFocus: Bool
    @FocusState private var focusLocation: FocusLocation?
    @Binding public var search: Search
    @Binding public var selectedIndex: Int
    private var isSearching: Bool {
        selectedIndex == 0
    }

    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0.0) {
                    SearchTextField(focusLocation: $focusLocation, text: $search.query, selecting: selectedIndex == 0)
                    .id(0)
                    .padding(.bottom, isSearching ? VisualConfigConstants.windowPadding : 4.0)
                    .animation(.bouncy(duration: VisualConfigConstants.slowAnimationDuration, extraBounce: 0.1),
                               value: isSearching)

                    WindowStack(focusLocation: $focusLocation, search: $search, selectedIndex: $selectedIndex)
                        .onExitCommand {
                            print("esc")
//                            closeAppAndOpenWindow()
//                            isFocused = false
                        }
                        .onKeyPress(.return) {
                            print("ret")
//                            closeAppAndOpenWindow()
//                            isFocused = false
                            return .handled
                        }
                        .onKeyPress(.init(Character(UnicodeScalar(127)))) {
                            print("del")
                            // TODO: fix
        //                    pulseColor = Color(scrollService.scrollState.selectedWindow.appIcon.dominantColor())
//                            pulse = true
        //                    deleteWindow()
                            return .handled
                        }
                }
                .padding(VisualConfigConstants.windowPadding)
            }
            .onChange(of: selectedIndex) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .now)
                    scrollView.scrollTo(min(selectedIndex, search.results.count), anchor: .bottom)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .didScrollUpNotification)) { _ in
                if selectedIndex > 0 {
                    selectedIndex -= 1
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .didScrollDownNotification)) { _ in
                if selectedIndex-ScrollConfigConstants.NUM_PRE_WINDOW_SCROLL_OPTIONS < search.results.count-1 {
                    selectedIndex += 1
                }
            }
        } // ScrollViewReader
        .frame(maxWidth: VisualConfigConstants.windowWidth, maxHeight: VisualConfigConstants.windowHeight)
        .focusEffectDisabled()
        .focusable()
        .focused($permAppFocus)
        .onAppear {
            focusLocation = .resultList
            permAppFocus = true
        }
        .onChange(of: isSearching) {
            print(isSearching)
            focusLocation = isSearching ? .searchBar : .resultList
        }
        .onKeyPress(.upArrow) {
            print("up")
            NotificationCenter.default.post(name: .didScrollUpNotification, object: nil)
            return .handled
        }
        .onKeyPress(.downArrow) {
            print("down")
            NotificationCenter.default.post(name: .didScrollDownNotification, object: nil)
            return .handled
        }
    }
}

//#Preview {
//    WindowSwitchView(scrollState: ScrollService().scrollState)
//}
