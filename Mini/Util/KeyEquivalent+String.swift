//
//  KeyEquivalent+None.swift
//  Mini
//
//  Created by Austin Vesich on 10/17/24.
//

import SwiftUI

extension KeyEquivalent {
    init(_ charString: String) {
        self.init(Character(charString))
    }
}
