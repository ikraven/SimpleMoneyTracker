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
                        Color(hex: expense.category.color)
                            .frame(width: 15, height: 200)
                        Text(expense.category.emoji!)
                            .font(.title2) // Emoji más grande
               
                        
                        
                        VStack(alignment: .leading) {
                            Text(expense.category.name)
                                .font(.title3) // Tamaño mayor que headline
                                .fontWeight(.bold) // En negrita para destacar
                            
                            Text(expense.creationDate.dayHour())
                                .font(.subheadline)
                        }
                        .padding(.vertical, 5) // Padding vertical más compacto
                        
                        if let comment = expense.comment {
                            Text(comment)
                                .font(.subheadline)
                                .lineLimit(1) // Limitar a una línea
                                .truncationMode(.tail) // Truncar con "..." si es largo
                        }
                        
                        Spacer()
                        
                        Text(expense.formatedAmount())
                            .font(.title3) // Tamaño mayor que headline
                            .fontWeight(.bold) // En negrita para destacar
                            .padding(.trailing)
                    
            }
            .frame(maxWidth: .infinity, maxHeight: 50)
            .padding(.vertical, 10) // Padding vertical ajustado
            .background(expense.category.getColor().opacity(0.15)) // Fondo más sutil
            .cornerRadius(12) // Esquinas más redondeadas
            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2) // Sombra suave
            .padding(.horizontal, 15) // Menos padding horizontal
        }
    
}

#Preview {
    let monsterCategory: Category = Category(id: UUID(), name: "Monster", color: "E7575E" , emoji: "💧")
    let sampleExpense: Expense = Expense(amount: 0, date: Date(), category: monsterCategory, comment: "prueba de comentario")
    
    ExpenseDetailComponent(expense: sampleExpense)
}
