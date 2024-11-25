//
//  WindowSwitchView.swift
//  Mini
//
//  Created by Austin Vesich on 10/25/24.
//

import SwiftUI

struct WindowSwitchView: View {
    
    private var windowManager = OrderedWindows()
    @State private var selectedIdx: Int = 0

    var body: some View {
        VStack(spacing: 16.0) {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(Array(windowManager.appIconsWithWindowDescriptions.enumerated()), id:\.0) { (index, appAndDesc) in
                    HStack(spacing: 16.0) {
                        Image(nsImage: appAndDesc.0)
                            .resizable()
                            .frame(width: 30.0, height: 30.0)
                            .scaledToFit()
                            .scaleEffect((selectedIdx==index) ? 1.2 : 1.0)
                        Text(appAndDesc.1)
                            .lineLimit(2)
                        Spacer()
                    }
                    .background {
                        if selectedIdx==index {
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
        .animation(.bouncy(duration: 0.1), value: selectedIdx)
    }
}

#Preview {
    WindowSwitchView()
}
