//
//  GeneralSettingsView.swift
//  Flick
//
//  Created by Austin Vesich on 6/21/25.
//

import SwiftUI
import Foundation
import LaunchAtLogin

struct GeneralSettingsView: View {
    @AppStorage("openAtLogin") private var openAtLogin: Bool = false
    @AppStorage("hotkeyOption") private var hotkeyOption: Shortcut = Shortcut.commandTab
    @AppStorage("selectWithMouse") private var selectWithMouse: Bool = true
    @AppStorage("scrollSensitivity") private var scrollSensitivity: Double = 6.0
        
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                SettingsBox(title: "Startup") {
                    HStack {
                        Text("Open Flick at Login")
                        Spacer()
                        Toggle(isOn: $openAtLogin) {}
                            .toggleStyle(.switch)
                            .onChange(of: openAtLogin) {
                                LaunchAtLogin.isEnabled = openAtLogin
                            }
                    }
                }
                
                SettingsBox(title: "Keyboard & Mouse") {
                    VStack(spacing: 8.0) {
                        HStack {
                            KeyboardKeyButton(selectedShortcut: $hotkeyOption,
                                              shortcutType: .controlTab)
                            Spacer()
                            KeyboardKeyButton(selectedShortcut: $hotkeyOption,
                                              shortcutType: .optionTab)
                            Spacer()
                            KeyboardKeyButton(selectedShortcut: $hotkeyOption,
                                              shortcutType: .commandTab)
                        }
                        HStack {
                            Text("Enable Click Controls")
                            Spacer()
                            Toggle(isOn: $selectWithMouse) {}
                                .toggleStyle(.switch)
                        }
                    }
                }
                
                SettingsBox(title: "Sensitivity") {
                    HStack(spacing: 24.0) {
                        Text("Scroll Sensitivity")
                        Slider(value: $scrollSensitivity, in: 1.0...10.0, step: 1.0) {
                        } minimumValueLabel: {
                            Text("Low")
                        } maximumValueLabel: {
                            Text("High")
                        }
                    }
                }
                
                SettingsBox(title: "Quit Apps",
                            subtitle: "Add apps to the list below, and Flick will quit them if you close their last window.") {
                    AppsToQuitList()
                }
            }
            .padding()
        }
    }
}

#Preview {
    GeneralSettingsView()
}
