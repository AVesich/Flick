//
//  SettingsView.swift
//  Flick
//
//  Created by Austin Vesich on 6/21/25.
//

import SwiftUI

struct SettingsView: View {
    
    private let categories: [SettingsOption] = [
        SettingsOption(title: "General", iconName: "gearshape"),
        SettingsOption(title: "Visuals", iconName: "photo")
    ]
    
    var body: some View {
        TabView {
            ForEach(categories) { category in
                Tab(category.title, systemImage: category.iconName) {
                    Text(category.title)
                }
            }
        }
        .scenePadding()
        .frame(maxWidth: 512.0, maxHeight: 512.0)
    }
}

#Preview {
    SettingsView()
}
