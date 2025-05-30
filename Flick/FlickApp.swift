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
        window.hidesOnDeactivate = true
    }
}

@main
struct FlickApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    private var scrollService = ScrollService() // Observed
    
    @State private var pumpEffectScale: CGFloat = 0.001
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                WindowSwitchView(scrollState: scrollService.scrollState)
                    .ignoresSafeArea()
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 16.0))
                    .scaleEffect(pumpEffectScale, anchor: .center)
                    .animation(.bouncy(duration: 0.15), value: pumpEffectScale)
                    .onChange(of: scrollService.scrollState.isSwitching) { (_, switching) in
                        if switching {
                            Task {
                                await scrollService.scrollState.updateAppList()
                            }
                            pumpEffectScale = 1.0
                        } else {
                            pumpEffectScale = 0.001
                        }
                    }
            }
        }
        .defaultPosition(.center)
        .windowResizability(.contentMinSize)
        MenuBarExtra("Flick", systemImage: "macwindow.on.rectangle") {
            Button("Close Flick") {
                NSApp.terminate(self)
            }
            Divider()
            Button("Flick Settings...") {
                NSApp.terminate(self)
            }
        }
    }
}
