//
//  PreviewMockData.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 22/2/25.
//
import Foundation
import SwiftUICore
import SwiftData



class PreviewMockData{
    
    let schema = Schema([
        Category.self,
        Expense.self,
        Account.self
    ])
    static let shared = PreviewMockData()
    let testContainer: ModelContainer
    //MARK: - CATEGORIES
    
    let monsterCategory: Category
    
    let dogFoodCategory: Category
    
    let selfCategory: Category
    
    //MARK: - Expenses
    let sampleExpenses: [Expense]
    
     
    //MARK: - PlanningExpense
    let gymPlanningExpense: Planning
    
    //MARK: - Container
    
    private init() {
            self.monsterCategory = Category(id: UUID(), name: "Monster", color: Color.green.toHex() , emoji: "🔋")
            self.dogFoodCategory = Category(id: UUID(), name: "Dog Food", color: Color.blue.toHex() , emoji: "🐶")
            self.selfCategory = Category(id: UUID(), name: "Self Care", color: Color.red.toHex() , emoji: "🏋")
        
        self.gymPlanningExpense = Planning(PlanningCategory: selfCategory, PlanningName: "Gym", Ammount: 77.5, period: .monthly, dayNumber: 10)
        
            self.sampleExpenses =
            [
                Expense(amount: 2, date: Date(), category: monsterCategory),
                Expense(amount: 1.8, date: Date(), category: dogFoodCategory),
                Expense(amount: 5, date: Date(), category: dogFoodCategory),
                Expense(amount: 2, date: Date(), category: monsterCategory),
                Expense(amount: 20, date: Date(), category: dogFoodCategory),
                Expense(amount: 1, date: Date(), category: monsterCategory),
                Expense(amount: 2, date: Date(), category: monsterCategory),
                Expense(amount: 1.8, date: Date(), category: dogFoodCategory),
                Expense(amount: 5, date: Date(), category: dogFoodCategory),
                Expense(amount: 2, date: Date(), category: monsterCategory),
                Expense(amount: 20, date: Date(), category: dogFoodCategory),
                Expense(amount: 1, date: Date(), category: monsterCategory)
            ]

            self.testContainer = try! ModelContainer(for: schema,
                                                     configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        }
    
}
