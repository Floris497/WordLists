//
//  WordListsApp.swift
//  Shared
//
//  Created by Floris Fredrikze on 22/11/2020.
//

import SwiftUI

@main
struct WordListsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.commands {
            CommandGroup(after: .sidebar) {
                Button(action: {
                    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                }) {
                    Text("Toggle Sidebar")
                }
                Divider()
            }
        }
    }
}
