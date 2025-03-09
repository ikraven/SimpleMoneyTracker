//
//  WeekDateView.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 26/1/25.
//

import SwiftUI

struct WeekDateView: View {
    //MARK: - Variables
    let minHeight: CGFloat = 80
    
    
    let weekOffset: Int
    private let calendar = Calendar.current
    @Binding var selectedDay: Date
    @State private var hStackWidth: CGFloat = 80 // Nueva variable para el ancho del HStack
    
    var body: some View {
        let dates = datesForWeek(offset: weekOffset)
        HStack(spacing: 0) {
            ForEach(dates, id: \.self) { date in
                VStack {
                    DaysComponent(date: date, 
                                isCurrentDate: calendar.isDate(Date(), inSameDayAs: date),
                                isSelected: calendar.isDate(selectedDay, inSameDayAs: date))
                }
                .frame(maxWidth: .infinity)
                .frame(height: minHeight)
                .onTapGesture {
                    selectedDay = date
                }
            }
            .id(selectedDay)
        }
        .frame(maxWidth: .infinity)
    }
    
    
    // Obtén las fechas para una semana específica
       private func datesForWeek(offset: Int) -> [Date] {
  
           guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else { return [] }

           return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
       }

    
}

#Preview {
    WeekDateView(weekOffset: 0, selectedDay: .constant(Date()))
    Divider()
    
}
