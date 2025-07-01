//
//  SettingsBox.swift
//  Flick
//
//  Created by Austin Vesich on 6/21/25.
//

import SwiftUI

struct SettingsBox<Content: View>: View {
    
    public let title: String
    public var subtitle: String? = nil
    public let content: () -> Content
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 16.0) {
                VStack(alignment: .leading, spacing: 0.0) {
                    Text(title)
                        .font(.system(size: 14.0, weight: .bold))
                    if subtitle != nil {
                        Text(subtitle!)
                            .opacity(VisualConfigConstants.selectionOpacity)
                    }
                }
                content()
            }
            .padding(8.0)
        }
    }
}

#Preview {
    SettingsBox(title: "Box", subtitle: "Subtitle.") {
        Text("Hello world!")
    }
}
