import Foundation
import SwiftData
@testable import SimpleMoneyTracker

let testModelContainer: ModelContainer = {
    let schema = Schema([
        Category.self,
        Expense.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    
    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}() 