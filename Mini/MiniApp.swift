//
//  MiniApp.swift
//  Mini
//
//  Created by Austin Vesich on 10/8/24.
//

import SwiftUI
import AppKit

final class BorderlessWindow: NSWindow {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
        
    var hotkeyService: HotkeyService!
    
    internal func applicationDidFinishLaunching(_ notification: Notification) {
        prepareWindow()
        hotkeyService = HotkeyService()
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
        window.hidesOnDeactivate = true
    }
}

@main
struct MiniApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .ignoresSafeArea()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16.0))
        }
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
