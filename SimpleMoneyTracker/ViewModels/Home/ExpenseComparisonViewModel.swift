//
//  ExpenseComparisonViewModel.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 15/3/25.
//

import SwiftData
import Foundation
import SwiftUICore

final class ExpenseComparisonViewModel: ObservableObject {
    private let modelContext: ModelContext
    
    
    @Published var currentMonthExpenses: [Expense] = []
    @Published var previousMonthExpenses: [Expense] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // Datos procesados para la gráfica
    @Published var comparisonData: [CategoryComparisonData] = []

    
    private var expensesService: ExpensesService {
        ExpensesService(modelContext: modelContext)
    }
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func loadData() async {
          DispatchQueue.main.async {
              self.isLoading = true
              self.errorMessage = nil
          }
          
          do {
              // Cargar datos en paralelo
              async let currentExpenses = expensesService.getCurrentPeriodExpenses(for: Date())
              async let previousExpenses = expensesService.getPastPeriodExpenses(for: Date())
              
              // Esperar a que ambas cargas terminen
              let (current, previous) = await (currentExpenses, previousExpenses)
              
              // Create a local copy to avoid capturing the array directly
              let currentCopy = current
              let previousCopy = previous
              
              DispatchQueue.main.async {
                  self.currentMonthExpenses = currentCopy
                  self.previousMonthExpenses = previousCopy
                  self.processComparisonData()
                  self.isLoading = false
              }
          } catch {
              DispatchQueue.main.async {
                  self.errorMessage = "Error al cargar los datos: \(error.localizedDescription)"
                  self.isLoading = false
              }
          }
      }
    
    private func processComparisonData() {
        // Agrupar gastos por categoría para ambos meses
        let currentByCategory = Dictionary(grouping: currentMonthExpenses, by: { $0.category })
        let previousByCategory = Dictionary(grouping: previousMonthExpenses, by: { $0.category })
        
        // Obtener todas las categorías únicas
        let allCategories = Set(currentByCategory.keys).union(previousByCategory.keys)
        
        // Crear datos de comparación
        comparisonData = allCategories.map { category in
            let currentTotal = currentByCategory[category]?.reduce(0) { $0 + $1.amount } ?? 0
            let previousTotal = previousByCategory[category]?.reduce(0) { $0 + $1.amount } ?? 0
            let difference = currentTotal - previousTotal
            let percentChange = previousTotal > 0 ? (difference / previousTotal) * 100 : 0
            
            return CategoryComparisonData(
                category: category.name,
                currentMonthAmount: currentTotal,
                previousMonthAmount: previousTotal,
                difference: difference,
                percentChange: percentChange
            )
        }.sorted(by: { abs($0.difference) > abs($1.difference) }) // Ordenar por mayor diferencia
    }
}

// Estructura para los datos de comparación por categoría
struct CategoryComparisonData: Identifiable {
    var id: String { category }
    let category: String
    let currentMonthAmount: Double
    let previousMonthAmount: Double
    let difference: Double
    let percentChange: Double
}
