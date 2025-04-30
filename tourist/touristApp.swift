//
//  touristApp.swift
//  tourist
//
//  Created by Shawn Conboy on 4/30/25.
//

import SwiftUI

@main
struct touristApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
