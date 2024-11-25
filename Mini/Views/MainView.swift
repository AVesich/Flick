//
//  ContentView.swift
//  Mini
//
//  Created by Austin Vesich on 10/8/24.
//

import SwiftUI
import ScreenCaptureKit

struct ContentView: View {
    
    @StateObject private var windowManager = WindowManager()
        
    var body: some View {
        VStack {
            HStack {
                Text(" mini")
                    .font(.olympe(size: 24.0))
                Spacer()
            }
            .padding(.horizontal, 24.0)
            Divider()
                .padding(.horizontal, 24.0)
            AppList(windowManager: windowManager)
                .padding(.horizontal, 16.0)
        }
        .padding(.top, 24.0)
        .frame(width: 340.0, height: 340.0)
        .onAppear {
            Task {
                await windowManager.beginUpdating()
            }
        }
    }
}

#Preview {
    ContentView()
}
