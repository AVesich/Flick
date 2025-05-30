//
//  WindowResizeView.swift
//  Mini
//
//  Created by Austin Vesich on 12/7/24.
//

import SwiftUI

struct WindowResizeView: View {
    
    public var scrollState: ScrollTrackerState
    @State var scrollSector: ScrollSector = .none
        
    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 16.0)
                .fill(.black.opacity(0.25))
                .background(.ultraThinMaterial)
                .overlay {
                    ZStack {
                        VStack(alignment: .center) {
                            Text("Swipe with 2 fingers to arrange the window.")
                        }
                        VStack() {
                            if scrollSector.arrangement.alignment.vertical == .bottom ||
                               scrollSector.arrangement.alignment.vertical == .center {
                                Spacer()
                            }
                            HStack() {
                                if scrollSector.arrangement.alignment.horizontal == .trailing ||
                                   scrollSector.arrangement.alignment.horizontal == .center {
                                    Spacer()
                                }
                                if scrollSector != .none {
                                    RoundedRectangle(cornerRadius: 16.0)
                                        .stroke(.white, lineWidth: 4.0)
                                        .padding(8.0)
                                        .frame(width: (scrollSector.arrangement.type == .twoByTwo) ? geometry.size.width/2.0 : geometry.size.width/3.0,
                                               height: (scrollSector.arrangement.height == .short) ? geometry.size.height/2.0 : geometry.size.height)
                                        .animation(.easeInOut(duration: 0.1), value: scrollSector)
                                }
                                if scrollSector.arrangement.alignment.horizontal == .leading ||
                                   scrollSector.arrangement.alignment.horizontal == .center {
                                    Spacer()
                                }
                            }
                            if scrollSector.arrangement.alignment.vertical == .top ||
                               scrollSector.arrangement.alignment.vertical == .center {
                                Spacer()
                            }
                        }
                        PanTrackerView(scrollSector: $scrollSector)
                    }
                    .frame(alignment: scrollSector.arrangement.alignment)
                }
        }
        .onChange(of: scrollSector) {
            NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .now)
        }
        .onDisappear() {
            scrollState.hasSelectedHorizontal = false // The horizontal selection has been handled
        }
    }
}

#Preview {
    WindowResizeView(scrollState: ScrollTrackerState())
}
