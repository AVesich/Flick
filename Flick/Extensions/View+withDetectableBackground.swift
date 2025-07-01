//
//  View+withDetectableBackground.swift
//  Flick
//
//  Created by Austin Vesich on 6/15/25.
//

import SwiftUI

extension View {
    func withDetectableBackground() -> some View {
        self.background {
            Rectangle()
                .fill(.black.opacity(0.001))
        }
    }
}
