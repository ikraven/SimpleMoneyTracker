//
//  ExpenseCreateSheetView.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 30/1/25.
//

import SwiftUI

struct ExpenseCreateSheetView: View {
    
    @State private var selectedCategory: Category? // Guarda la categoría seleccionada
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack{
            if let category = selectedCategory {
                AddExpenseComponent(category: category
                                    ,isPresented: $isPresented)
                
            }else {
                CategorySelectorComponent{ selected in
                    selectedCategory = selected
                }
            }
            
            
        }
    }
}


#Preview {
    ExpenseCreateSheetView(isPresented: .constant(false))
}
