//
//  MockContainer.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 8/2/25.
//

import Foundation
import SwiftData

@MainActor
var mockContainer: ModelContainer{
    let schema = Schema([
        Category.self,
        Expense.self
    ])
    
    do{
        let container = try ModelContainer(for: schema, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        return container
    }catch{
        fatalError("Failed to create container")
    }
}
