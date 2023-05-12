//
//  SpaceXLaunchesApp.swift
//  SpaceXLaunches
//
//  Created by Ty Daniels on 5/12/23.
//

import SwiftUI

@main
struct SpaceXLaunchesApp: App {
    init() {
        Dependencies.shared.register(type: NetworkProvider.self, component: NetworkProvider())
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
