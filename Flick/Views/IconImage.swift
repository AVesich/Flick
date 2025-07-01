//
//  IconImage.swift
//  Flick
//
//  Created by Austin Vesich on 6/22/25.
//

import AppKit
import SwiftUI

struct IconImage: View {
    public let icon: NSImage
    
    var body: some View {
        Image(nsImage: icon)
            .resizable()
            .frame(width: 30.0, height: 30.0)
            .scaledToFit()
    }
}

#Preview {
    IconImage(icon: NSImage(systemSymbolName: "app.fill", accessibilityDescription: nil)!)
}
