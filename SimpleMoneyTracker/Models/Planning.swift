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
    
    /// Día de asignación del gasto mensual
    private var _dayNumber: Int? = 1

    /// Setter validacion de 1 - 30
    public var dayNumber: Int? {
        get { _dayNumber }
        set {
            guard (1...30).contains(newValue ?? 1) else {
                print("Invalid day number: \(String(describing: newValue)). Must be between 1 and 30.")
                return
            }
            _dayNumber = newValue
        }
    }
    
    ///Dia de semana del gasto
    private var _weekDayNumber: Int?
    
    /// Setter validacion de 1 - 30
    public var weekDayNumber: Int? {
        get { _weekDayNumber }
        set {
            guard (1...7).contains(newValue ?? 1) else {
                print("Invalid day number: \(String(describing: newValue)). Must be between 1 and 7.")
                return
            }
            _weekDayNumber = newValue
        }
    }
    
    public var period: Period
    
    init(PlanningCategory: Category, PlanningName: String, Ammount: Double, period: Period, dayNumber: Int? = nil, weekDayNumber: Int? = nil) {
        self.PlanningCategory = PlanningCategory
        self.PlanningName = PlanningName
        self.Ammount = Ammount
        self.period = period

        switch period {
        case .weekly:
            guard self._weekDayNumber != nil else {
                fatalError("Weekly expenses require a valid weekDayNumber.")
            }
            self._weekDayNumber = weekDayNumber
            self._dayNumber = nil
        case .monthly:
            guard self.dayNumber != nil  else {
                fatalError("Monthly expenses require a valid dayNumber between 1 and 30.")
            }
            self._dayNumber = dayNumber
            self._weekDayNumber = nil
        case .yearly:
            self._dayNumber = nil
            self._weekDayNumber = nil
        }
    }
    
    public enum Period: String, Codable, CaseIterable, Identifiable{
        case weekly
        case monthly
        case yearly
        
        public var id: String { self.rawValue }
    }
    
}
