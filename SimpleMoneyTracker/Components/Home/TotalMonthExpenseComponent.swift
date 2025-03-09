//
//  TotalMonthExpenseComponent.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 23/2/25.
//

import SwiftUI

/// Componente que muestra el total gastado del periodo actual ( mes )
/// con una pequeña comparación del periodo anterior
struct TotalMonthExpenseComponent: View {
    //MARK: - Variables
    let currentDate: Date
    let currentExpense: Double
    let pastExpense: Double?
    let moreFinished: Bool
    
    init(currentDate: Date, currentExpense: Double, pastExpense: Double?) {
        self.currentDate = currentDate
        self.currentExpense = currentExpense
        self.pastExpense = pastExpense
        self.moreFinished = currentExpense > pastExpense ?? 0
    }
    
    var body: some View {
        VStack{
            if(pastExpense != nil && pastExpense! > 0){
                VStack(alignment: .leading){
                    Text("\( Image(systemName: moreFinished ? "chart.line.uptrend.xyaxis" : "chart.line.downtrend.xyaxis")) Tendencia")
                        .foregroundColor(moreFinished ? .red : .green)
                        .frame(alignment: .leading)
                        .padding(.bottom)
                    HStack{
                        let dif =  !moreFinished ?  pastExpense! - currentExpense :  currentExpense - pastExpense!
                        Text("Estas gastando \(dif.formatedAmount()) \(moreFinished ? "mas" : "menos") que el periodo pasado")
                            .font(.callout)
                    }
                }
                .padding()
            }else{
                VStack(alignment: .leading){
                    Text("\( Image(systemName: "chart.line.flattrend.xyaxis")) Tendencia")
                        .padding()
                    Text("No hay datos del periodo pasado")
                        .font(.callout)
                        .frame(alignment: .leading)
                        .padding(.bottom)
                        
                    
                }
                .padding()
                
            }

            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground)) // Se adapta a modo claro/oscuro
        .cornerRadius(12)
        .overlay( // Agregamos un borde que será visible en ambos modos
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
        .shadow(radius: 2) // Opcional para un efecto más elegante
        
    }
}

#Preview ("More Past expense") {
    let calendar = Calendar.current
    let currentComponets =   DateComponents(year: 2025, month: 2, day: 15)
    var current = calendar.date(from: currentComponets)!
    let pastomponets =   DateComponents(year: 2025, month: 1, day: 15)
    var past = calendar.date(from: pastomponets)!
    
    TotalMonthExpenseComponent(
        currentDate: current,
        currentExpense: 325.14,
        pastExpense: 400
    )
}

#Preview ("Less past expense") {
    let calendar = Calendar.current
    let currentComponets =   DateComponents(year: 2025, month: 2, day: 15)
    var current = calendar.date(from: currentComponets)!
    
    TotalMonthExpenseComponent(
        currentDate: current,
        currentExpense: 325.14,
        pastExpense: 0
    )
}
#Preview ("No past expense") {
    let calendar = Calendar.current
    let currentComponets =   DateComponents(year: 2025, month: 2, day: 15)
    var current = calendar.date(from: currentComponets)!
    
    TotalMonthExpenseComponent(
        currentDate: current,
        currentExpense: 325.14,
        pastExpense: nil
    )
}
