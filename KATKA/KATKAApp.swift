//
//  KATKAApp.swift
//  KATKA
//
//  Created by Екатерина Кузмичева on 21.06.2024.
//

import SwiftUI

@main
struct KATKAApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeScreen()
        }
    }
}
