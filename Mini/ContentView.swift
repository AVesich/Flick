//
//  ContentView.swift
//  Mini
//
//  Created by Austin Vesich on 10/8/24.
//

import SwiftUI

struct ContentView: View {
        
    var body: some View {
        VStack {
            HStack {
                Text("Mini")
                    .padding(.horizontal, 24.0)
                    .font(.system(size: 18.0).monospaced().bold())
                Spacer()
            }
            Divider()
                .padding(.horizontal, 24.0)
            AppList(apps: WindowManager.shared.openApps)
                .padding(.horizontal, 16.0)
        }
        .padding(.top, 24.0)
        .frame(width: 340.0, height: 340.0)
    }
}

#Preview {
    ContentView()
}
