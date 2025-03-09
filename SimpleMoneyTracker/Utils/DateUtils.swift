//
//  DateUtils.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 7/2/25.
//

import Foundation

/// Utiliades de fechas
public struct DateUtils {
    
    /// Enum para determinar el rango de fechas que devolverá
    public enum RangeType: String, CaseIterable, Identifiable {
        case day = "Día"
        case week = "Semana"
        case month = "Mes"
        case year = "Año"
        
        
        public var id: String { self.rawValue }
    }
    
    
    /// Devuelve el dia 1 y último del mes anterior al dado
    public static func getPastMonthDates(for date: Date) -> (Date, Date) {
        let calendar = Calendar.current
        
        // Obtenemos los componentes de la fecha actual
        guard let previousMonth = calendar.date(byAdding: .month, value: -1, to: date),
              let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: previousMonth))else {
            return (date, date)
        }
       
        return (startOfMonth, previousMonth)
    }
    
    public static func getFisrtAndLastDate(for date: Date, with rangeType: DateUtils.RangeType) -> (Date, Date) {
        let calendar = Calendar.current
        
        switch rangeType {
        case .day:
            let startOfDay = calendar.startOfDay(for: date)
            guard let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date) else {
                return (date, date)
            }
            return (startOfDay, endOfDay)
            
        case .week:
            
            guard let sunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)),
                  let saturday = calendar.date(byAdding: .day, value: 6, to: sunday) else {
                return (date, date)
            }
            return (calendar.startOfDay(for: sunday),
                    calendar.date(bySettingHour: 23, minute: 59, second: 59, of: saturday) ?? saturday)
        case .month:
            if let range = calendar.range(of: .day, in: .month, for: date),
               let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) {
                let lastDay = calendar.date(byAdding: .day, value: range.count - 1, to: startOfMonth)
                return (startOfMonth, lastDay!)
            }
            return (date, date)
        case .year:
            let year = calendar.component(.year, from: date)
            let startComponents = DateComponents(year: year, month: 1, day: 1)
            let endComponents = DateComponents(year: year, month: 12, day: 31)
            
            guard let startOfYear = calendar.date(from: startComponents),
                  let endOfYear = calendar.date(from: endComponents) else {
                return (date, date)
            }
            return (calendar.startOfDay(for: startOfYear),
                    calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endOfYear) ?? endOfYear)
        }
    }
}
