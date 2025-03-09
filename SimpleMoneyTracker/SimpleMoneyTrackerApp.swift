//
//  SimpleMoneyTrackerApp.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 22/1/25.
//

import SwiftUI
import SwiftData

@main
struct SimpleMoneyTrackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Category.self,
            Expense.self,
            ExpenseAgregate.self,
            Account.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            // Inicializar datos por defecto
            let initService = DataInitializationService(modelContext: container.mainContext)
            initService.initializeDefaultData()
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
