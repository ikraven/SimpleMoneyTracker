//
//  ExpensesService.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 28/1/25.
//

import SwiftData
import Foundation
import Observation


public class ExpensesService {
    let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    // MARK: - Lectura
    
    /// Sumar los montos de todos los gastos de un mes específico
    /// - Parameter date: Fecha de referencia para el mes del cual se quieren obtener los gastos
    /// - Returns: Total de gastos para el mes especificado
    func getExpenseByMonth(for date: Date) -> Double{
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
               
        let predicate = #Predicate<Expense> { expense in
             expense.creationDate >= startOfMonth && expense.creationDate < endOfMonth
         }
         
         let sortDescriptor = SortDescriptor<Expense>(\.creationDate)
         let descriptor = FetchDescriptor<Expense>(
             predicate: predicate,
             sortBy: [sortDescriptor]
         )
         
         do {
             let expenses = try modelContext.fetch(descriptor)
             return expenses.reduce(0.0) { $0 + $1.amount }
         } catch {
             print("Error fetching expenses for month: \(error)")
             return 0.0
         }
        
    }
    
    /// Devuelte los gastos del dia 1 del mes hasta el dia dado
    /// - Parameter date: Fecha de referencia para el mes del cual se quieren obtener los gastos
    /// - Returns: Total de gastos para el mes especificado
    func getCurrentPeriodExpenses(for date: Date) -> [Expense]{
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
   
        return getExpensesBetweenDates(beginDate: startOfMonth, endDate: date)
        
    }
    
    /// Devuelte los gastos del dia 1 del mes hasta el dia dado
    /// - Parameter date: Fecha de referencia para el mes del cual se quieren obtener los gastos
    /// - Returns: Total de gastos para el mes especificado
    func getPastPeriodExpenses(for date: Date) -> [Expense]{
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let startOfPastMonth = calendar.date(byAdding: .month, value: -1, to: startOfMonth)!
        let pastMonthLastDay = calendar.date(byAdding: .month, value: -1, to: date)!
        print("First past month Day ->  \(startOfPastMonth)")
        print("Last past month Day ->  \(pastMonthLastDay)")
        return getExpensesBetweenDates(beginDate: startOfPastMonth, endDate: pastMonthLastDay)
        
    }
    
    /// Obtiene todos los gastos de una fecha específica
    /// - Parameter date: Fecha desde la cual se quieren obtener los gastos
    /// - Returns: Array de gastos para la fecha especificada ordenados por fecha de creación
    func getExpenses(for date: Date) -> [Expense] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        return getExpensesBetweenDates(beginDate: startOfDay, endDate: endOfDay)
    }
    
    func getAllExpenses() -> [Expense]{
        return (try? modelContext.fetch(FetchDescriptor<Expense>())) ?? []
    }
    
    // Sumar los montos de una fecha específica
    func getTotalAmount(for date: Date) -> Double {
        let expenses = getExpenses(for: date)
        return expenses.reduce(0.0) { $0 + $1.amount }
    }
    
    /// Agregar un nuevo gasto
    func addExpense(amount: Double, date: Date, category: Category) {
        let expense = Expense( amount: amount, date: date, category: category)
        modelContext.insert(expense)
    }
    
    /// Elimina un gasto
    /// - Parameter expense: Gasto a borrar
    func deleteExpense(_ expense: Expense) {
        modelContext.delete(expense)
    }
    
    /// Devuelve los gastos entre dos fechas
    func getExpensesBetweenDates(beginDate: Date, endDate: Date) -> [Expense]{
        let predicate = #Predicate<Expense> { expense in
            expense.creationDate >= beginDate && expense.creationDate < endDate
        }
        
        let sortDescriptor = SortDescriptor<Expense>(\.creationDate)
        let descriptor = FetchDescriptor<Expense>(
            predicate: predicate,
            sortBy: [sortDescriptor]
        )
        
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching expenses: \(error)")
            return []
        }
    }
    
    func getAggregateForMonth(for date: Date) -> [ExpenseAgregate]{
        
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
        print("\(startOfMonth)")
        print("\(endOfMonth)")
        let predicate = #Predicate<ExpenseAgregate> { expense in
            expense.Month >= startOfMonth && expense.Month < endOfMonth
         }
         
        let descriptor = FetchDescriptor<ExpenseAgregate>(predicate: predicate)
         
         do {
             let expenses = try modelContext.fetch(descriptor)
             print("\(expenses.count)")
             return expenses
         } catch {
             print("Error fetching expenses for month: \(error)")
             return []
         }
    }
    
    func getAllAgregates() -> [ExpenseAgregate]{
        return (try? modelContext.fetch(FetchDescriptor<ExpenseAgregate>())) ?? []
    }
    // MARK: - Escritura
    
    /// Crea o actualiza un gasto
    /// - Parameter expense: Gasto a crear o editar
    func createOrUpdateExpense(expense: Expense) {
        let expenseID = expense.id
        let predicate = #Predicate<Expense> { $0.id == expenseID }
        let descriptor = FetchDescriptor<Expense>(predicate: predicate)

        do {
            let results = try modelContext.fetch(descriptor)
            if let existingExpense = results.first {
                existingExpense.amount = expense.amount
                existingExpense.creationDate = expense.creationDate
                existingExpense.comment = expense.comment
                existingExpense.category = expense.category
                let ammountDiff = existingExpense.amount - expense.amount
                UpdateCreateAgregate(for: expense, with: ammountDiff)
            } else {
                modelContext.insert(expense)
                UpdateCreateAgregate(for: expense)
            }
            try modelContext.save()
           
        } catch {
            print("Error during createOrUpdateExpense: \(error)")
        }
    }
    
    
    /// Recalcula el agregado de gastos
    func recalculateExpensesAgregate() -> Bool{
        do {
            try modelContext.delete(model: ExpenseAgregate.self)
            print("Agregados borrados")
        } catch {
            print("Failed to delete Agregates.")
        }
        print("-------------")
        let expenses = getAllExpenses()
        for expense in expenses {
            UpdateCreateAgregate(for: expense)
        }
        let totalExpenses = expenses.reduce(0.0) { $0 + $1.amount }
        print("-------------")
        print("Total Expenses =>  \(totalExpenses)")
        print("Contador Expenses =>  \(expenses.count)")
        let agregates = getAllAgregates()
        let totalAgregates = agregates.reduce(0.0) { $0 + $1.Ammount }
        let totalAgregatesCount = agregates.reduce(0.0) { $0 + Double($1.ExpensesCount) }
        print("Total Agregate =>  \(totalAgregates)")
        print("Contador Agregate =>  \(totalAgregatesCount)")
        return true
    }
    
    
    private func UpdateCreateAgregate(for expense: Expense, with diff: Double? = nil){
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: expense.creationDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        // Use date range comparison that's compatible with SwiftData
        let startOfDayForExpense = calendar.startOfDay(for: expense.creationDate)
        let endOfDayForExpense = calendar.date(byAdding: .day, value: 1, to: startOfDayForExpense)!
        
        let predicate = #Predicate<ExpenseAgregate> { agregate in
            agregate.Month >= startOfDayForExpense && agregate.Month < endOfDayForExpense
        }
        
        let descriptor = FetchDescriptor<ExpenseAgregate>(
            predicate: predicate
        )
        
        do{
            let agregates = try modelContext.fetch(descriptor)
            if agregates.isEmpty {
                //Creamos entrada
                let defaultAccount = ExpenseAgregate(
                    Month: startOfDay, // Use startOfDay instead of endOfDay for consistency
                    Ammount: diff ?? expense.amount,
                    ExpensesCount: 1
                )
                modelContext.insert(defaultAccount)
                try modelContext.save()
                print("Agregado creado \(defaultAccount.Month) => \(defaultAccount.Ammount) ")
            }else{
                //Modificamos entrada
                let agregate = agregates.first!
                agregate.ExpensesCount += 1
                agregate.Ammount += diff ??  expense.amount
                try modelContext.save()
                print("Agregado actualizado \(agregate.Month) => \(agregate.Ammount) => \(agregate.ExpensesCount)")
            }
            
        } catch {
            print("Error actualizando agregado:  \(error)")
        }
    }
    
}
