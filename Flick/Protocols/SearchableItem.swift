//
//  SearchableItem.swift
//  Flick
//
//  Created by Austin Vesich on 6/18/25.
//

import SwiftUI

protocol SearchableItem {
    func matches(query searchQuery: String) -> Bool
    
    @ViewBuilder func cell(isSelected: Bool) -> any View
}
