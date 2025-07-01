//
//  SettingsView.swift
//  Flick
//
//  Created by Austin Vesich on 6/21/25.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        TabView {
            Tab("General", systemImage: "gearshape") {
                GeneralSettingsView()
            }
            Tab("Visuals", systemImage: "photo") {
                VisualSettingsView()
            }
        }
        .frame(width: 550.0, height: 512.0)
    }
}

#Preview {
    SettingsView()
}
