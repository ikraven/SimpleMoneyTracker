//
//  SummaryExpense.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 5/2/25.
//
import Foundation
/// Entidad de resumen de gastos
/// Agregado de gastos por fecha (mes, día, año...)
public class SummaryExpense: Identifiable{
    /// Total gastado
    var amount: Double
    /// Categoría del gasto
    var category: Category?
    /// Número de gastos de la categoría
    var count: Int = 0
    
    /// Flag para animaciones
    var isAnimated: Bool = false
    
    init(amount: Double) {
        self.amount = amount
    }
    
    public func formatedAmount() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current // Usa la configuración regional del usuario
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }

}
