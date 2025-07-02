//
//  MiniApp.swift
//  Mini
//
//  Created by Austin Vesich on 10/8/24.
//

import SwiftUI
import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    
    internal func applicationDidFinishLaunching(_ notification: Notification) {
        prepareWindow()
    }
    
    private func prepareWindow() {
        if let window = NSApp.windows.first {
            makeBackgroundClear(from: window)
            makeBorderless(from: window)
        }
    }
    
    private func makeBackgroundClear(from window: NSWindow) {
        // Make background clear
        window.backgroundColor = .clear
    }
    
    private func makeBorderless(from window: NSWindow) {
        // Make background clear
        window.styleMask = [.borderless]
        window.hasShadow = false
        window.styleMask.insert(.fullSizeContentView)
//        window.hidesOnDeactivate = true
    }
}

@main
struct FlickApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var appState
    private var scrollService = ScrollService()
    
    @FocusState private var permAppFocus: Bool
    @State private var pumpEffectScale: CGFloat = .minimumDetectable
    @State private var pulse: Bool = false
    @State private var pulseColor: Color = .red
    @StateObject private var search: Search = Search(appList: AllAppList.shared, windowList: ActiveWindowList.shared)
    @State private var selectedIndex: Int = ScrollConfigConstants.NUM_PRE_WINDOW_SCROLL_OPTIONS
    private var isVisible: Bool {
        pumpEffectScale == 1.0
    }
    
    var body: some Scene {
        WindowGroup {
            MainView(selectedIndex: selectedIndex)
                .environmentObject(search)
                .background(.black)
                .clipShape(.rect(cornerRadius: VisualConfigConstants.largeCornerRadius))
                .shadow(color: .white.opacity(0.25), radius: 6.0)
                .scaleEffect(pumpEffectScale, anchor: .center)
                .onAppear {
                    pumpEffectScale = .minimumDetectable
                }
//                .modifier(BackgroundPulse(enabled: pulse, color: pulseColor))
                .modifier(Pump(pumping: $pulse))
                .animation(.bouncy(duration: VisualConfigConstants.fastAnimationDuration), value: pumpEffectScale)
                .focusable()
                .focusEffectDisabled()
                .focused($permAppFocus)
                .onShowApp {
                    permAppFocus = true
                    resetValues()
                    pumpEffectScale = 1.0
                    ScrollTrackingSharedState.shared.isVisible = true
                }
                .onHideApp {
                    pumpEffectScale = .minimumDetectable
                    ScrollTrackingSharedState.shared.isVisible = false
                }
                .onChange(of: permAppFocus) {
                    if permAppFocus {
                        print("Perm focus on")
                    } else {
                        print("Perm focus off")
                    }
                }
                .onExitCommand {
                    NSApp.fakeHide()
                }
                .onHotkeyUp {
                    if selectedIndex != 0 {
                        NSApp.fakeHide()
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: .didScrollUpNotification)) { _ in
                    if isVisible && selectedIndex > 0 {
                        selectedIndex -= 1
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: .didScrollDownNotification)) { _ in
                    if isVisible && selectedIndex-ScrollConfigConstants.NUM_PRE_WINDOW_SCROLL_OPTIONS < search.results.count-1 {
                        selectedIndex += 1
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: .deletePressedNotification)) { _ in
                    if isVisible {
                        pulse = true
//                        Task {
//                            await search.refreshWindowList()
//                        }
                    }
                }
                .padding(48.0)
        }
        .defaultPosition(.center)
        .windowResizability(.contentMinSize)
                
        MenuBarExtra("Flick", systemImage: "macwindow.on.rectangle") {
            Button("Close Flick") {
                NSApp.terminate(self)
            }
            Divider()
            SettingsLink() {
                Text("Flick Settings...")
            }
        }
        
        Settings {
            SettingsView()
                .environmentObject(search)
                .modelContainer(FlickDataModel.shared.modelContainer)
        }
    }
    
    private func resetValues() {
        Task {
            await search.refreshWindowList()
        }
        search.query = ""
        selectedIndex = ScrollConfigConstants.NUM_PRE_WINDOW_SCROLL_OPTIONS
    }
}
