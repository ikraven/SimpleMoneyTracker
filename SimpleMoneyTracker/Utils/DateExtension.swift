//
//  DateUtils.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 26/1/25.
//
import SwiftUI

/// Extension de fechas
extension Date
{
    // Computed properties para descomponer la fecha
    func dayOfWeek() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "EEE" // Día de la semana
        return formatter.string(from: self)
    }
    
    /// Devuelve el la hora y minitos
    func formattedDate() -> String  {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy" // Día con dos dígitos, mes en texto completo y año
        formatter.locale = Locale(identifier: "es_ES") // Asegurar que el mes salga en español
        return formatter.string(from: self)
    }
    /// Devuelve el la hora y minitos
    func dayHour() -> String  {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // Horas
        return formatter.string(from: self)
    }
    
    /// Devuelve el número de día
    func dayNumber() -> String  {
        let formatter = DateFormatter()
        formatter.dateFormat = "d" // Día del mes
        return formatter.string(from: self)
    }
    
    /// Devuelve el mes formateado
    func monthText() -> String  {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM" // Día del mes
        return formatter.string(from: self)
    }
    
    /// Devuelve el mes formateado
    func yearText() -> String  {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY" // Día del mes
        return formatter.string(from: self)
    }
}
