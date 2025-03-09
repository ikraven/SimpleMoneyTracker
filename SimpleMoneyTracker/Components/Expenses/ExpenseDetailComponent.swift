//
//  ExpenseDetailComponent.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 29/1/25.
//

import SwiftUI

struct ExpenseDetailComponent: View {
    @State var expense: Expense
    
    var body: some View {
        HStack {
            Text(expense.category.emoji!)
                .padding(.leading)
            
            VStack(alignment: .leading) {
                Text(expense.category.name)
                    .foregroundColor(expense.category.getColor().opacity(0.8))
                    .font(.headline)
                    
                Text(expense.creationDate.dayHour())
                    .foregroundColor(expense.category.getColor().opacity(0.8))
                    .font(.subheadline)
            }.padding()
            Spacer()
            Text(expense.formatedAmount())
                .foregroundColor(expense.category.getColor().opacity(0.8))
                .font(.headline)
                .padding()
        }
        .frame(maxWidth: .infinity)
        .background(expense.category.getColor().opacity(0.15)) // Fondo más sutil
        .cornerRadius(10)
        .padding(.horizontal, 20)
    }
    
    // Función auxiliar para determinar el color del texto
    private func textColor(for backgroundColor: Color) -> Color {
        // Convertimos el color a sus componentes RGB
        guard let components = UIColor(backgroundColor).cgColor.components,
              components.count >= 3 else {
            return .black
        }
        
        // Calculamos la luminosidad usando la fórmula estándar
        let luminance = 0.299 * components[0] + 0.587 * components[1] + 0.114 * components[2]
        
        // Si la luminosidad es mayor a 0.5, el color es considerado claro
        return luminance > 0.5 ? .black : .white
    }
}

#Preview {
    let monsterCategory: Category = Category(id: UUID(), name: "Monster", color: "E7575E" , emoji: "💧")
    let sampleExpense: Expense = Expense(amount: 0, date: Date(), category: monsterCategory)
    
    ExpenseDetailComponent(expense: sampleExpense)
}
