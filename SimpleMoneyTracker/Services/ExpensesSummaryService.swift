//
//  ExpensesSummaryService.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 5/2/25.
//
import SwiftData
import Foundation


/// Servicio encargado de devolver los datos de resumen
public class ExpensesSummaryService{
    let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    private let calendar = Calendar.current
    
    // MARK: - Categorías

    /// Devuelve el total gastado en una categoría
    /// - Parameter id: Id de la categoría a buscar
    func getTotalForCategory(for id: UUID) -> Double{
        
        // Crear el predicado para filtrar por categoría
          let predicate = #Predicate<Expense> { expense in
              expense.category.id == id
          }
        
        let descriptor = FetchDescriptor<Expense>(predicate: predicate)
        do{
            let expenses = try modelContext.fetch(descriptor)
            return expenses.reduce(0) { $0 + $1.amount }
        }catch{
            print("Error al obtener el total: \(error)")
            return 0.0
        }
    }
   
    
    /// Devuelve los datos de resumen de gastos
    /// - Parameter date: Fecha desde la que devolverá el resumen
    /// - Parameter rangeType: Rango que devolverá, dia, mes o año
    func getSummary(for date: Date, with rangeType: DateUtils.RangeType) -> [SummaryExpense] {
        let dates = DateUtils.getFisrtAndLastDate(for: date, with: rangeType)
        let beginDate: Date = dates.0
        let endDate: Date = dates.1
        
        // Crear el predicado para filtrar por fecha
          let predicate = #Predicate<Expense> { expense in
              expense.creationDate >= beginDate && expense.creationDate <= endDate
          }
        
        
        // Obtener todos los gastos en el rango de fechas
            let descriptor = FetchDescriptor<Expense>(predicate: predicate)
            
            do {
                let expenses = try modelContext.fetch(descriptor)
                
                // Agrupar por categoría
                let groupedExpenses = Dictionary(grouping: expenses) { $0.category }
                
                // Crear los SummaryExpense
                return groupedExpenses.map { (category, expenses) in
                    let total = expenses.reduce(0) { $0 + $1.amount }
                    let summary = SummaryExpense(amount: total)
                    summary.category = category
                    summary.count = expenses.count
                    return summary
                }
            } catch {
                print("Error al obtener los gastos: \(error)")
                return []
            }
    }
    
    func getDatesSummary(for categoryId: UUID, with today: Date = Date()) ->  [DateSummaryExpense]{
        
        if let firstMonthDay = calendar.date(from: calendar.dateComponents([.year, .month], from: today)),
           let beginDate = calendar.date(byAdding: .month, value: -6, to: firstMonthDay){
            
            // Crear el predicado para filtrar por fecha
              let predicate = #Predicate<Expense> { expense in
                  expense.creationDate >= beginDate && expense.category.id == categoryId
              }
            // Obtener todos los gastos en el rango de fechas
                let descriptor = FetchDescriptor<Expense>(predicate: predicate)
                
                do {
                    let expenses = try modelContext.fetch(descriptor)
                    
                    
                    // 🔹 Obtener los últimos 12 meses asegurando valores predeterminados
                    let last12Months: [Date] = (0..<6).compactMap { offset in
                        let date = calendar.date(byAdding: .month, value: -offset, to: Date())!
                        let components = calendar.dateComponents([.year, .month], from: date)
                        return (calendar.date(from: components)!)
                    }.reversed()

                    
                    // Agrupar por categoría
                    let groupedAndSummed = Dictionary(grouping: expenses, by: { expense in
                        let components = calendar.dateComponents([.year, .month], from: expense.creationDate)
                        return calendar.date(from: components)!
                    }).mapValues { expenses in
                        expenses.reduce(0) { $0 + $1.amount } // Sumamos los `amount`
                    }
                  
                    let fullMapped = last12Months.map { (date) -> (date: Date, total: Double) in
                        return (date, groupedAndSummed[date] ?? 0) // Usa 0 si no hay datos
                    }
                    return fullMapped.map { (key, totalAmount) in
                        let summary = DateSummaryExpense(amount: totalAmount, expenseDate: key)
                        return summary
                    }
                    
                   

                } catch {
                    print("Error al obtener los gastos: \(error)")
                    return []
                }
            
        }
        return []
    }

    
}


