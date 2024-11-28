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
            window.center()
            window.setFrame(window.frame.offsetBy(dx: 0, dy: -window.frame.size.height/2+64), display: true)
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
    var scrollService = ScrollService() // Observed
//    var hotkeyService = HotkeyService()
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .ignoresSafeArea()
//                .background(.thinMaterial)
//                .clipShape(RoundedRectangle(cornerRadius: 16.0))
            if scrollService.scrollState.isTrackingScrolling {
                WindowSwitchView(windowData: scrollService.windows,
                                 selectedIndex: scrollService.scrollState.scrolledIdx,
                                 horizontalDrag: scrollService.scrollState.horiScrollDelta)
                    .ignoresSafeArea()
                    .background(.thickMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16.0))
            }
        }
        .windowResizability(.contentMinSize)
        MenuBarExtra("Mini", systemImage: "hand.pinch.fill") {
            Button("Close Mini") {
                NSApp.terminate(self)
            }
//            Divider()
//            Button("Mini Settings...") {
//                NSApp.terminate(self)
//            }
        }
    }
}
