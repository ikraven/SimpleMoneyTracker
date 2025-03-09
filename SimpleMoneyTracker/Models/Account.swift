//
//  Account.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 5/3/25.
//
import Foundation
import SwiftData

/// Cuenta de gasto, de momentos se usa como entidad única para el límite, a futuro dejar asociar gasto a Cuenta
@Model
final public class Account {
    /// Identificador del gasto
    @Attribute(.unique) public var id: UUID
    /// Límite de gasto asociado a cuenta (de momento mensual)
    public var limit: Double
    /// Monto disponible en cuenta
    public var remaining: Double
    /// Nombre de la cuenta
    public var name: String
    
    init(id: UUID, limit: Double, remaining: Double, name: String) {
        self.id = id
        self.limit = limit
        self.remaining = remaining
        self.name = name
    }
}
