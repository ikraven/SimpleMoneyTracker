//
//  ExpenseCreateSheetView.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 30/1/25.
//

import SwiftUI

struct ExpenseCreateSheetView: View {
    
    @State private var selectedCategory: Category? // Guarda la categoría seleccionada
    @Binding var editExpense: Expense? // Gasto que se editará o creará si es nulo
    @Binding var isPresented: Bool
    
 
    var body: some View {
        NavigationStack{
            if let category = selectedCategory {
                AddExpenseComponent(expense: editExpense,
                                    category: category,
                                    isPresented: $isPresented)
                
            }else {
                CategorySelectorComponent{ selected in
                    selectedCategory = selected
                }
            }
            
            
        }.onAppear {
            if let expense = editExpense {
                selectedCategory = expense.category
            }
        }
    }
}


#Preview {
    ExpenseCreateSheetView(editExpense: .constant(nil), isPresented: .constant(false))
}
