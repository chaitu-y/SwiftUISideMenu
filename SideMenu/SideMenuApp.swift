//
//  SideMenuApp.swift
//  SideMenu
//
//  Created by HeadsUp on 6/12/24.
//

import SwiftUI

@main
struct SideMenuApp: App {
    var body: some Scene {
        WindowGroup {
            SideMenuView(sideMenuWidth: 300.0) {
                SideMenu()
            } content: {
                MainView()
            }
        }
    }
}


struct MainView: View {
    var body: some View {
        NavigationView {
            Text("Main View")
                .navigationTitle("Main View")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("", systemImage: "line.3.horizontal") {
                            NotificationCenter.default.post(name: .showSideView, object: nil)
                        }
                    }
                }
        }
        .ignoresSafeArea()
    }
}

struct SideMenu: View {
    var body: some View {
        List {
            Text("Side menu")
        }
    }
}
