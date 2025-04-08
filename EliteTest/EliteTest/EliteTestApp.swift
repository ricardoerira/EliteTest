//
//  EliteTestApp.swift
//  EliteTest
//
//  Created by andres on 8/04/25.
//

import SwiftUI

@main
struct EliteTestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
