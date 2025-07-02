//
//  VisualSettingsView.swift
//  Flick
//
//  Created by Austin Vesich on 6/21/25.
//

import SwiftUI

struct VisualSettingsView: View {
    
    @AppStorage("windowWidth") private var windowWidth: Double = 300.0
    @AppStorage("windowHeight") private var windowHeight: Double = 300.0
    @AppStorage("animationSpeedModifier") private var animationSpeedModifier: Double = 0.0

    var body: some View {
        VStack {
            SettingsBox(title: "Window Size") {
                VStack(spacing: 8.0) {
                    HStack() {
                        Text("Window Width")
                        Spacer()
                        Stepper(value: $windowWidth, in: 300...600, step: 50) {
                            Text(windowWidth.formatted())
                        }
                    }
                    HStack() {
                        Text("Window Height")
                        Spacer()
                        Stepper(value: $windowHeight, in: 300...600, step: 50) {
                            Text(windowHeight.formatted())
                        }
                    }
                }
            }

            SettingsBox(title: "Animations") {
                HStack(spacing: 24.0) {
                    Text("Animation Speed")
                    Slider(value: $animationSpeedModifier, in: -0.1...0.1, step: 0.05) {
                    } minimumValueLabel: {
                        Text("Snappier")
                    } maximumValueLabel: {
                        Text("Smoother")
                    }
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    VisualSettingsView()
}
