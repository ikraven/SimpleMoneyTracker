//
//  MonthView.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 9/3/25.
//


import SwiftUI

struct MonthView: View {
    let date: Date
    @Binding var selectedDay: Date
    let calendar = Calendar.current
    @State var isSelected: Bool = false
    @State var expensesDays: [ExpenseAgregate] = []
    @Environment(\.modelContext) private var modelContext
    @AppStorage("isFirstLaunch") private var isFirstLaunch = false
   
    
    private var expensesService: ExpensesService {
        ExpensesService(modelContext: modelContext)
    }
    
    
    var body: some View {
            VStack(spacing: 15) {
                // Nombres de los días de la semana, ajustados según la localización
                let weekdaySymbols = rotatedWeekdaySymbols()
                HStack(spacing: 0) {
                    ForEach(weekdaySymbols, id: \.self) { symbol in
                        Text(symbol.uppercased())
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                // Cuadrícula de días del mes
                let days = daysInMonth(for: date, using: calendar)
                let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
                
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(days, id: \.self) { day in
                        if let day = day {
                            let isToday = isCurrentMonth && day == calendar.component(.day, from: Date())
                            VStack(spacing: 4){
                                ZStack{
                                    Circle()
                                    .fill(Color.mainColor.opacity(0.2))
                                        .frame(width: 45)
                                        .opacity(isToday ? 1 : 0)
                                    VStack{
                                        Text("\(day)")
                                            .font(.body)
                                            .foregroundColor(isToday ? .mainColor : .primary)
                                            .cornerRadius(5)
                                    }
                                }
                                
                                // Fixed height container for expense amount
                                VStack {
                                    if let registro = expensesDays.first(where: { calendar.component(.day, from: $0.Month) == day }) {
                                        Text(registro.Ammount.formatedAmount())
                                            .font(.system(size: 12))
                                    }
                                }
                                .frame(height: 16) // Fixed height for expense text area
                            }
                            .onTapGesture {
                                selectedDay = selectedDate(numDays: day, date: date)
                            }
                            .frame(height: 70)
                        }else{
                            Text("")
                        }
                    }
                }
            }
            .onAppear{
                if(expensesDays.isEmpty){
                    expensesDays = expensesService.getAggregateForMonth(for: date)
                }
                    
            }
            .padding()
        }
        
        // MARK: - Propiedades Computadas
    func getColor(isCurrentDate: Bool, isSelected: Bool) -> Color {
        switch (isCurrentDate, isSelected) {
        case (true, true): return .primary
        case (true, false): return .mainColor
        case (false, true): return Color(UIColor.systemBackground)
        case (false, false): return .primary
        }
    }
    private func selectedDate(numDays: Int, date: Date) -> Date {
        let begin = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let addedDate = calendar.date(byAdding: .day, value: numDays - 1, to: begin)!
        return addedDate
    }
    
        /// Verifica si el mes mostrado es el mes actual
        private var isCurrentMonth: Bool {
            calendar.isDate(date, equalTo: Date(), toGranularity: .month)
        }
        
        /// Formatea el mes y el año según la localización
        private var monthYearString: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            formatter.locale = Locale.current
            return formatter.string(from: date).capitalized
        }
        
        // MARK: - Funciones Auxiliares
        
        /// Genera un array con los días del mes, incluyendo espacios en blanco según la localización
        private func daysInMonth(for date: Date, using calendar: Calendar) -> [Int?] {
            let range = calendar.range(of: .day, in: .month, for: date)!
            let firstWeekday = firstWeekdayOfMonth(for: date, using: calendar)
            
            // Calcular espacios en blanco iniciales según el primer día de la semana
            let leadingBlanks = (firstWeekday - calendar.firstWeekday + 7) % 7
            
            // Crear el array con espacios en blanco y días
            var days: [Int?] = Array(repeating: nil, count: leadingBlanks)
            days += range.map { $0 }
            
            // Completar la cuadrícula hasta un múltiplo de 7
            let totalCells = Int(ceil(Double(days.count) / 7.0)) * 7
            let trailingBlanks = totalCells - days.count
            days += Array(repeating: nil, count: trailingBlanks)
            
            return days
        }
        
        /// Obtiene el día de la semana del primer día del mes (1 = domingo, 2 = lunes, etc.)
        private func firstWeekdayOfMonth(for date: Date, using calendar: Calendar) -> Int {
            var components = calendar.dateComponents([.year, .month], from: date)
            components.day = 1
            let firstDay = calendar.date(from: components)!
            return calendar.component(.weekday, from: firstDay)
        }
        
        /// Rota los nombres de los días de la semana según la configuración regional
        private func rotatedWeekdaySymbols() -> [String] {
            // Create a calendar with the current locale to ensure proper localization
            var localizedCalendar = Calendar.current
            localizedCalendar.locale = Locale.current
            
            // Use veryShortWeekdaySymbols which respects the device's locale settings
            let symbols = localizedCalendar.veryShortWeekdaySymbols
            let firstWeekdayIndex = localizedCalendar.firstWeekday - 1 // Índice base 0
            let rotated = Array(symbols[firstWeekdayIndex...] + symbols[..<firstWeekdayIndex])
            return rotated
        }
 
}


#Preview {
    MonthView(date: Date(),selectedDay: .constant(Date()))
}
#Preview("Selected") {
    
    let testContainer = PreviewMockData.shared.testContainer
    
    let testContext = testContainer.mainContext

    let monsterCategory = PreviewMockData.shared.monsterCategory
    
    let dogFoodCategory = PreviewMockData.shared.dogFoodCategory
    
    testContainer.mainContext.insert(monsterCategory)
    
    testContainer.mainContext.insert(dogFoodCategory)
    
   
    let arrayExpenses = PreviewMockData.shared.sampleExpenses

    for expense in arrayExpenses{
        testContext.insert(expense)
    }
      
    let aggregate = ExpenseAgregate(Month: Date(), Ammount: 333.33, ExpensesCount: 33)
    
    testContainer.mainContext.insert(aggregate)
    
    let calendar = Calendar.current
    

    let firstAgregate = ExpenseAgregate(Month: Date(), Ammount: 333.33, ExpensesCount: 33)
    let nextAgregate = ExpenseAgregate(Month:  calendar.date(byAdding: .day, value: 1, to: Date())!, Ammount: 333.33, ExpensesCount: 33)
    let nextAgregate2 = ExpenseAgregate(Month:  calendar.date(byAdding: .day, value: 5, to: Date())!, Ammount: 333.33, ExpensesCount: 33)
    
    return MonthView(date: Date(), selectedDay: .constant(Date()), isSelected: true, expensesDays: [firstAgregate, nextAgregate, nextAgregate2])

    
    
   
}
