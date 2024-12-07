//
//  PanTrackerView.swift
//  Mini
//
//  Created by Austin Vesich on 11/30/24.
//

import AppKit
import SwiftUI

class TouchTrackingView: NSView {
    
    var touchCount: Binding<Int>!
            
    override init (frame frameRect: NSRect) {
        super.init(frame: frameRect)
        allowedTouchTypes = [.indirect]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func swipe(with event: NSEvent) {
        print("swiping")
    }
    
    override func touchesBegan(with event: NSEvent) {
        super.touchesBegan(with: event)
        
        touchCount.wrappedValue = event.touches(matching: .touching, in: self).count
    }
    
    override func touchesEnded(with event: NSEvent) {
        super.touchesEnded(with: event)
        
        touchCount.wrappedValue = event.touches(matching: .touching, in: self).count
    }
}

enum ScrollSector {
    // Default for 2x2
    case full
    
    // 2x2 layout
    case topLeftQuarter
    case topRightQuarter
    case leftHalf
    case rightHalf
    case bottomLeftQuarter
    case bottomRightQuarter
    
    // 3x3 layout
    case topLeftSixth
    case topMiddleSixth
    case topRightSixth
    case leftSixth
    case middleSixth
    case rightSixth
    case bottomLeftSixth
    case bottomMiddleSixth
    case bottomRightSixth
}

struct PanTrackerView: NSViewRepresentable {
    @Binding var scrollSector: ScrollSector
    @State private var touchCount: Int = 0
    
    class Coordinator: NSObject {
        public var touchCount: Binding<Int>!
        public var view: NSView!
        public var scrollSector: Binding<ScrollSector>!
        
        private var SENSITIVITY_BOX_SIZE: CGFloat = 256.0
        
        private var totalX: CGFloat = 0.0
        private var totalY: CGFloat = 0.0
        private var scrollIsCurrent: Bool = false

        @objc func handleEvent(_ event: NSEvent) {
            guard event.type == .scrollWheel else {
                return
            }

            trackScrollPosition(fromEvent: event)
            scrollSector.wrappedValue = currentSector()
        }
        
        private func trackScrollPosition(fromEvent event: NSEvent) {
            if event.phase == .ended {//|| event.momentumPhase == .ended {
                scrollIsCurrent = false
                totalX = 0.0
                totalY = 0.0
            } else if event.phase == .began {
                scrollIsCurrent = true
            }
            
            if scrollIsCurrent {
                totalX += event.scrollingDeltaX
                totalY += event.scrollingDeltaY
            }
                    
            print("(\(totalX), \(totalY))")
        }
        
        private func currentSector() -> ScrollSector {
            var point = CGPoint(x: totalX, y: totalY)
            
            if touchCount == 2 {
                
            } else { // 2+ behaves as 3
                
            }
            
            return .leftHalf
        }
    }

    func makeNSView(context: Context) -> NSView {
        let view = TouchTrackingView() // Touches are not tracked through scrollWheel events, so it's done in the view itself
        view.touchCount = $touchCount
        
        context.coordinator.view = view
        context.coordinator.touchCount = $touchCount
        context.coordinator.scrollSector = $scrollSector
        NSEvent.addLocalMonitorForEvents(matching: [.scrollWheel, .swipe]) { event in
            context.coordinator.handleEvent(event)
            return event
        }
        
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        // No updates needed
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

}
