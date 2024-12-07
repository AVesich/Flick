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
//        window.hidesOnDeactivate = true
    }
}

@main
struct MiniApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    private var scrollService = ScrollService() // Observed
    
    @State private var pumpEffectScale: CGFloat = 0.5
    
    var body: some Scene {
        WindowGroup {
//            if scrollService.scrollState.isArrangingWindows {
            WindowResizeView()
//            } else if scrollService.scrollState.isSwitching {
//                WindowSwitchView(scrollState: scrollService.scrollState)
//                    .ignoresSafeArea()
//                    .background(.ultraThinMaterial)
//                    .clipShape(RoundedRectangle(cornerRadius: 16.0))
//                    .scaleEffect(pumpEffectScale, anchor: .center)
//                    .animation(.bouncy(duration: 0.1, extraBounce: 0.1), value: pumpEffectScale)
//                    .onAppear {
//                        Task {
//                            await scrollService.scrollState.updateAppList()
//                        }
//                        pumpEffectScale = 1.0
//                    }
//                    .onDisappear {
//                        pumpEffectScale = 0.5
//                    }
//            }
        }
        .defaultPosition(.center)
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
