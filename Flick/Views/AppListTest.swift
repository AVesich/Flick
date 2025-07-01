//
//  AppListTest.swift
//  Flick
//
//  Created by Austin Vesich on 6/18/25.
//

import SwiftUI

struct AppListTest: View {
    @State private var appList = AllAppList.shared
    
    var body: some View {
        VStack(spacing: 8.0) {
            ForEach(appList.apps.shuffled()) { app in
                HStack(spacing: 16.0) {
                    Image(nsImage: app.icon)
                    Text(app.name)
                }
            }
        }
        .onAppear {
            appList.updateAppList()
        }
    }
}

#Preview {
    AppListTest()
}
