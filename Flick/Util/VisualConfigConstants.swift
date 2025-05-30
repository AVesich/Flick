//
//  Constants.swift
//  Mini
//
//  Created by Austin Vesich on 5/29/25.
//

import Foundation

struct VisualConfigConstants {
    static let windowWidth: CGFloat = 256.0
    static let windowHeight: CGFloat = 256.0
    
    static let windowPadding: CGFloat = 10.0
    
    static let cellPadding: CGFloat = 6.0
    static let cellContentHeight: CGFloat = 30.0
    static let cellContentWidth: CGFloat = windowWidth - 2*windowPadding - 2*cellPadding
    static let cellHeight: CGFloat = cellContentHeight + 2*cellPadding
    static let cellWidth: CGFloat = cellContentWidth + 2*cellPadding
    
    static let selectionOpacity: CGFloat = 0.2
}
