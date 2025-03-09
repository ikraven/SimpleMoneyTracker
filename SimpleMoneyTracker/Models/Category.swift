//
//  Category.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 22/1/25.
//

import Foundation
import SwiftData
import UIKit
import SwiftUI

/// Categoría de un gasto
@Model
final public class Category {
    /// Identificador de la categoría
    @Attribute(.unique) public var id: UUID
    /// Nombre de la categoría
    public var name: String
    /// Color de la categoría
    public var color: String
    /// Emoji de la categoría
    public var emoji: String?
    /// Indica si es al categoría por defecto
    /// ( no puede borrarse y los gastos de moverán a esta)
    public var isDefault: Bool = false
    
    /// Relación con gasto
    @Relationship(deleteRule: .cascade, inverse: \SimpleMoneyTracker.Expense.category)
    public var expenses: [Expense] = []
    
    /// Devuelve el Color
    public func getColor() -> Color {
        return Color(hex: color)
    }
    
    public init(id: UUID, name: String, color: String, emoji: String) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
    }
}
