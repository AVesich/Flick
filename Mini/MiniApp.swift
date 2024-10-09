//
//  MiniApp.swift
//  Mini
//
//  Created by Austin Vesich on 10/8/24.
//

import SwiftUI
import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
        
    var hotkeyLoop: HotkeyService!
    
    internal func applicationDidFinishLaunching(_ notification: Notification) {
        prepareWindow()
        hotkeyLoop = HotkeyService()
    }
    
    private func prepareWindow() {
        if let window = NSApp.windows.first {
            removeStoplights(from: window)
            makeBackgroundClear(from: window)
        }
    }

    private func removeStoplights(from window: NSWindow) {
        // Hide stoplights
        window.standardWindowButton(.closeButton)?.isHidden = true
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
    }

    private func makeBackgroundClear(from window: NSWindow) {
        // Make background clear
        window.backgroundColor = .clear
    }
}


@main
struct MiniApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .ignoresSafeArea()
                .background(.black)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        MenuBarExtra("Mini", systemImage: "hand.pinch.fill") {
            Button("Close Mini") {
                NSApp.terminate(self)
            }
            Divider()
            Button("Mini Settings...") {
                NSApp.terminate(self)
            }
        }
    }
}
