//
//  WindowCell.swift
//  Mini
//
//  Created by Austin Vesich on 11/25/24.
//

import SwiftUI
import AppKit

struct WindowCell: View {
    
    public var index: Int
    public var appAndDesc: (NSImage, String, Int, pid_t)
    public var selectedIndex: Int
    public var maxIndex: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 16.0) {
            Image(nsImage: appAndDesc.0)
                .resizable()
                .frame(width: 30.0, height: 30.0)
                .scaledToFit()
                .scaleEffect((selectedIndex==index) ? 1.2 : 1.0)
            Text(appAndDesc.1)
                .lineLimit(2)
                .scaleEffect((selectedIndex==index) ? 1.07 : 1.0)
            Spacer()
        }
        .frame(height: 30.0)
        .padding(6.0)
        .background {
            if selectedIndex==index {
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(.secondary.opacity(0.2))
                    .frame(width: 236.0, height: 42.0)
            }
        }
        .animation(.bouncy(duration: 0.15, extraBounce: 0.25), value: selectedIndex)
        .id(index)
    }
}
