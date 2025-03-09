//
//  ExpenseAgregate.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 1/3/25.
//

import Foundation
import SwiftData


/// Modelo de agregado de gastos por mes
@Model
final public class ExpenseAgregate {
    /// Día de referencia
    public var Month: Date
    /// Total gastado en fecha
    public var Ammount: Double
    /// Contador de gastos de fecha
    public var ExpensesCount: Int
    
    init(Month: Date, Ammount: Double, ExpensesCount: Int) {
        self.Month = Month
        self.Ammount = Ammount
        self.ExpensesCount = ExpensesCount
    }
}
