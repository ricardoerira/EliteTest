//
//  EliteTestApp.swift
//  EliteTest
//
//  Created by Wilson Ricardo Erira  on 8/04/25.
//

import SwiftUI
import GoogleMaps

@main
struct EliteTestApp: App {
    let persistenceController = PersistenceController.shared
    init() {
        GMSServices.provideAPIKey("AIzaSyAQG7VtsQAVGb7eXaJ7-Kvh1YQ0HnoGavo")
    }
    
    var body: some Scene {
        
        WindowGroup {
            AddEstateView(viewModel: AddEstateViewModel())
        }
    }
}
