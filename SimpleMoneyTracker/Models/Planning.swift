//
//  Planning.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 1/5/25.
//
import Foundation
import SwiftData

/// Gasto planificado
@Model
final public class Planning {
    /// Categoría del gasto asociado
    public var PlanningCategory: Category
    
    /// Nombre del gato planificado
    public var PlanningName: String
    
    /// Cantidad del gasto
    public var Ammount: Double
    
    /// Día de asignación del gasto
    private var _dayNumber: Int = 1

    // Setter validacion de 1 - 30
    public var dayNumber: Int {
        get { _dayNumber }
        set {
            guard (1...30).contains(newValue) else {
                print("Invalid day number: \(newValue). Must be between 1 and 30.")
                return
            }
            _dayNumber = newValue
        }
    }
    
    init(PlanningCategory: Category, PlanningName: String, Ammount: Double, _dayNumber: Int) {
        self.PlanningCategory = PlanningCategory
        self.PlanningName = PlanningName
        self.Ammount = Ammount
        self._dayNumber = _dayNumber
    }
    
    
}
