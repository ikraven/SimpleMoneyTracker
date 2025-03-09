//
//  Expense.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 22/1/25.
//

import Foundation
import SwiftData

/// Representa un gasto
@Model
final public class Expense {
    /// Identificador del gasto
    @Attribute(.unique) public var id: UUID
    /// Cantidad gastada
    public var amount: Double
    /// Fecha de creación del gasto
    public var creationDate: Date
    /// Comentario a cerca del gasto
    public var commnt: String?
    /// Relación con la categoría
    @Relationship public var category: SimpleMoneyTracker.Category
    
    /// Devuelve la cantidad en un string formateado
    public func formatedAmount() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current // Usa la configuración regional del usuario
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
    
    public init(amount: Double, date: Date, category: Category) {
        self.id = UUID()
        self.amount = amount
        self.creationDate = date
        self.category = category
    }
    
    
}
