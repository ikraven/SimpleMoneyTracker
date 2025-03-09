//
//  DateSummaryExpense.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 22/2/25.
//

import Foundation

/// Modelo de resumen por fecha
class DateSummaryExpense: Identifiable{
    /// Total gastado
    var amount: Double = 0.0
    /// Categoría del gasto
    var category: Category?
    /// Fecha del gasto
    var expenseDate: Date

    
    /// Flag para animaciones
    var isAnimated: Bool = false
    
    init(amount: Double, category: Category? = nil, expenseDate: Date) {
        self.amount = amount
        self.category = category
        self.expenseDate = expenseDate
        self.isAnimated = false
    }
    
}
