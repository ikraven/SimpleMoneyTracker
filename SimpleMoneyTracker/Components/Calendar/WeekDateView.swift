//
//  WeekDateView.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 26/1/25.
//

import SwiftUI

struct WeekDateView: View {
    //MARK: - Variables
    
    let weekOffset: Int
    private let calendar = Calendar.current
    @Binding var selectedDay: Date
    
    var body: some View {
        let dates = datesForWeek(offset: weekOffset)
        GeometryReader { geometry in
            HStack {
                ForEach(dates, id: \.self) { date in
                    VStack {
                        DaysComponent(date: date, isCurrentDate: calendar.isDate( Date() , inSameDayAs: date) ? true : false, isSelected: calendar.isDate( selectedDay , inSameDayAs: date) ? true : false)
                    }
                    .frame(width: geometry.size.width / 9, height: 100)
                    .onTapGesture {
                        selectedDay = date
                    }
                }
                .id(selectedDay)
            }
            .padding()
            
        }
        
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
