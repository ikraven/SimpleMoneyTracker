//
//  HomeViewModel.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 28/2/25.
//

import Foundation
import Combine
import SwiftUICore
import SwiftData

class HomeViewModel: ObservableObject {
    @Published var currentMonthExpense: Double = 0
    @Published var previousMonthExpense: Double = 0
    @Published var categoryAmmount: [CategoryAmmount] = []
    @Published var limit: Double = 0
    @Published var isLoading = true
    
    
    private let modelContext: ModelContext
    
    private var expensesService: ExpensesService {
        ExpensesService(modelContext: modelContext)
    }
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func loadData() {
        isLoading = true
        print("Starting loadData")
        let currentMonthExpenses = expensesService.getCurrentPeriodExpenses(for: Date())
        
        // Cargar datos del mes actual
        currentMonthExpense = getTotal(expenses: currentMonthExpenses)
        print("Current month expense: \(currentMonthExpense)")
        
        categoryAmmount = getCategotyGrouped(expenses: currentMonthExpenses)
        
        let pastMonth = DateUtils.getPastMonthDates(for: Date())
        
        let pastExpenses = expensesService.getExpensesBetweenDates(beginDate: pastMonth.0, endDate: pastMonth.1)
        
        previousMonthExpense = pastExpenses.reduce(0.0) { $0 + $1.amount }
        print("Previous month expense: \(previousMonthExpense)")
        limit = getLimit()
        print("Limit: \(limit)")
        isLoading = false
    }
    
    private func getTotal(expenses:  [Expense]) -> Double{
        return expenses.reduce(0) { $0 + $1.amount }
    }
    
    private func getCategotyGrouped(expenses: [Expense]) -> [CategoryAmmount]{
        
        // Agrupar por categoría
        let groupedExpenses = Dictionary(grouping: expenses) { $0.category }
        
        // Crear los SummaryExpense
        return groupedExpenses.map { (category, expenses) in
            let total = expenses.reduce(0) { $0 + $1.amount }
            let summary = CategoryAmmount(category: category, totalAmmount: total)
            return summary
        }.sorted{
            $0.TotalAmmount > $1.TotalAmmount
        }
    }
    private func getLimit() -> Double{
        let descriptor = FetchDescriptor<Account>()
        
        do {
            let accounts = try modelContext.fetch(descriptor)
            print(accounts.count)
            if accounts.isEmpty {
                return 0.0
            }
            return accounts.first?.limit ?? 0.0
        } catch {
            return 0.0
        }
    }
    
}

/// Struct para guardar el agregado de gasto por categoría
struct CategoryAmmount: Identifiable{
    public var id: UUID
    public var Category: Category
    public var TotalAmmount: Double
    
    init(category: Category, totalAmmount: Double) {
        self.Category = category
        self.TotalAmmount = totalAmmount
        self.id = UUID()
    }
}
