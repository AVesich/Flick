//
//  WindowSwitchView.swift
//  Mini
//
//  Created by Austin Vesich on 10/25/24.
//

import SwiftUI

struct WindowSwitchView: View {
    
    public var windowData: [(NSImage, String)]
    public var selectedIndex: Int

    var body: some View {
        VStack(spacing: 16.0) {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(Array(windowData.enumerated()), id:\.0) { (index, appAndDesc) in
                    HStack(spacing: 16.0) {
                        Image(nsImage: appAndDesc.0)
                            .resizable()
                            .frame(width: 30.0, height: 30.0)
                            .scaledToFit()
                            .scaleEffect((selectedIndex==index) ? 1.2 : 1.0)
                        Text(appAndDesc.1)
                            .lineLimit(2)
                            .scaleEffect((selectedIndex==index) ? 1.05 : 1.0)
                        Spacer()
                    }
                    .background {
                        if selectedIndex==index {
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(.secondary.opacity(0.2))
                                .frame(width: 236.0, height: 42.0)
//                                .scaleEffect(x: 1.07, y: 1.4)
                        }
                    }
                }
                .padding(16.0)
            }
        }
        .frame(maxWidth: 256.0, maxHeight: 256.0)
        .animation(.bouncy(duration: 0.15, extraBounce: 0.25), value: selectedIndex)
    }
}

#Preview {
    WindowSwitchView(windowData: OrderedWindows().appIconsWithWindowDescriptions,
                     selectedIndex: 0)
}
