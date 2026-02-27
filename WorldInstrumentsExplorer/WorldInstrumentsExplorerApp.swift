//
//  WorldInstrumentsExplorerApp.swift
//  WorldInstrumentsExplorer
//
//  Created by zhengbei on 2026/2/7.
//

import SwiftUI

@main
struct WorldInstrumentsExplorerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        #if os(macOS)
        .defaultSize(width: 1280, height: 820)
        #endif
    }
}
