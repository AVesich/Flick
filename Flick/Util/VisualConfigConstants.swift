//
//  Constants.swift
//  Mini
//
//  Created by Austin Vesich on 5/29/25.
//

import Foundation
import SwiftUI

struct VisualConfigConstants {
    @AppStorage("windowWidth") static public var windowWidth: Double = 300.0
    @AppStorage("windowHeight") static public var windowHeight: Double = 300.0
    @AppStorage("animationSpeedModifier") static private var animationSpeedModifier: Double = 0.0

    static let windowPadding: CGFloat = 10.0
    
    static let cellPadding: CGFloat = 6.0
    static let cellContentHeight: CGFloat = 30.0
    static var cellContentWidth: CGFloat {
        windowWidth - 2*windowPadding - 2*cellPadding
    }
    static let cellHeight: CGFloat = cellContentHeight + 2*cellPadding
    static var cellWidth: CGFloat {
        cellContentWidth + 2*cellPadding
    }
    
    static let searchBarHeight: CGFloat = 22.0
    
    static let selectionOpacity: CGFloat = 0.2
    static let selectionPumpStrength: CGFloat = 0.1
    
    static var slowAnimationDuration: CGFloat {
        0.2 + animationSpeedModifier
    }
    static var fastAnimationDuration: CGFloat {
        0.15 + animationSpeedModifier
    }
    
    static let largeCornerRadius: CGFloat = 24.0
    static let smallCornerRadius: CGFloat = 14.0
}
