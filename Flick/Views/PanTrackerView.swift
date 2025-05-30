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

enum WindowArrangementType {
    case twoByTwo
    case twoByThree
}

enum WindowArrangementHeight {
    case short
    case tall
}

enum ScrollSector {
    // Default for 2x2
    case none
    
    // 2x2 layout
    case topLeftQuarter
    case topRightQuarter
    case leftHalf
    case rightHalf
    case bottomLeftQuarter
    case bottomRightQuarter
    
    // 2x3 layout
    case topLeftSixth
    case topMiddleSixth
    case topRightSixth
    case leftThird
    case middleThird
    case rightThird
    case bottomLeftSixth
    case bottomMiddleSixth
    case bottomRightSixth
    
    var arrangement: (type: WindowArrangementType, height: WindowArrangementHeight, alignment: Alignment) {
        switch self {
        case .none: return (.twoByTwo, .tall, .center)
        case .topLeftQuarter: return (.twoByTwo, .short, .topLeading)
        case .topRightQuarter: return (.twoByTwo, .short, .topTrailing)
        case .leftHalf: return (.twoByTwo, .tall, .leading)
        case .rightHalf: return (.twoByTwo, .tall, .trailing)
        case .bottomLeftQuarter: return (.twoByTwo, .short, .bottomLeading)
        case .bottomRightQuarter: return (.twoByTwo, .short, .bottomTrailing)
        case .topLeftSixth: return (.twoByThree, .short, .topLeading)
        case .topMiddleSixth: return (.twoByThree, .short, .top)
        case .topRightSixth: return (.twoByThree, .short, .topTrailing)
        case .leftThird: return (.twoByThree, .tall, .leading)
        case .middleThird: return (.twoByThree, .tall, .center)
        case .rightThird: return (.twoByThree, .tall, .trailing)
        case .bottomLeftSixth: return (.twoByThree, .short, .bottomLeading)
        case .bottomMiddleSixth: return (.twoByThree, .short, .bottom)
        case .bottomRightSixth: return (.twoByThree, .short, .bottomTrailing)
        }
    }
    
    // FOR DEBUG
    var name: String {
        switch self {
        case .none: return "None"
        case .topLeftQuarter: return "Top Left Quarter"
        case .topRightQuarter: return "Top Right Quarter"
        case .leftHalf: return "Left Half"
        case .rightHalf: return "Right Half"
        case .bottomLeftQuarter: return "Bottom Left Quarter"
        case .bottomRightQuarter: return "Bottom Right Quarter"
        case .topLeftSixth: return "Top Left Sixth"
        case .topMiddleSixth: return "Top Middle Sixth"
        case .topRightSixth: return "Top Right Sixth"
        case .leftThird: return "Left Third"
        case .middleThird: return "Middle Third"
        case .rightThird: return "Right Third"
        case .bottomLeftSixth: return "Bottom Left Sixth"
        case .bottomMiddleSixth: return "Bottom Middle Sixth"
        case .bottomRightSixth: return "Bottom Right Sixth"
        }
    }
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
            print(scrollSector.wrappedValue.name)
        }
        
        private func trackScrollPosition(fromEvent event: NSEvent) {
            if event.phase == .ended {//|| event.momentumPhase == .ended {
                scrollIsCurrent = false
                totalX = 0.0
                totalY = 0.0
                scrollSector.wrappedValue = .none
            } else if event.phase == .began {
                scrollIsCurrent = true
            }
            
            if scrollIsCurrent {
                totalX += event.scrollingDeltaX
                totalY += event.scrollingDeltaY
            }
                    
//            print("(\(totalX), \(totalY))")
        }
        
        private func currentSector() -> ScrollSector {
            var point = CGPoint(x: totalX, y: totalY)
            
            print(touchCount.wrappedValue)
            
            if touchCount.wrappedValue == 2 {
                if totalY > (SENSITIVITY_BOX_SIZE/2.0) { // bottom third (snap to bottom corner)
                    return (totalX >= 0.0) ? .bottomRightQuarter : .bottomLeftQuarter
                } else if totalY < -(SENSITIVITY_BOX_SIZE/2.0) { // top third (snap to top corner)
                    return (totalX >= 0.0) ? .topRightQuarter : .topLeftQuarter
                } else { // middle third (snap to side)
                    return (totalX >= 0.0) ? .rightHalf : .leftHalf
                }
            } else { // 2+ behaves as 3
                let third = (totalX < -(SENSITIVITY_BOX_SIZE/2.0)) ? 0 : (totalX > (SENSITIVITY_BOX_SIZE/2.0)) ? 2 : 1 // Left to right: 0 1 2
                if totalY > (SENSITIVITY_BOX_SIZE/2.0) { // bottom third (snap to bottom corner)
                    return (third == 1) ? .bottomMiddleSixth : (third == 0) ? .bottomLeftSixth : .bottomRightSixth
                } else if totalY < -(SENSITIVITY_BOX_SIZE/2.0) { // top third (snap to top corner)
                    return (third == 1) ? .topMiddleSixth : (third == 0) ? .topLeftSixth : .topRightSixth
                } else { // middle third (snap to side)
                    return (third == 1) ? .middleThird : (third == 0) ? .leftThird : .rightThird
                }
            }
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
