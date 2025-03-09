//
//  AddExpenseComponent.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 29/1/25.
//

import SwiftUI
import SwiftData

struct AddExpenseComponent: View {
    @Environment(\.modelContext) private var modelContext
    @State var category: Category
    @State var expense: Expense
    @State private var amountText: String = ""
    @Binding var isPresented: Bool
    @FocusState private var isTextFieldFocused: Bool
    
    private var expensesService: ExpensesService {
        ExpensesService(modelContext: modelContext)
    }
    
    
    init(category: Category, isPresented: Binding<Bool>) {
        self._category = State(initialValue: category)
        self._expense = State(initialValue: Expense(amount: 0, date: Date(), category: category))
        self._isPresented = isPresented
    }

    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    
    var isFormValid: Bool {
        expense.amount > 0 &&
        Double(amountText.replacingOccurrences(of: ",", with: ".")) != nil
    }
    
    
    var body: some View {
        ExpenseDetailComponent(expense: expense)
        DatePicker("",selection: $expense.creationDate)
                .labelsHidden()
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
        HStack{
            TextField("EUR", text: $amountText)
                .keyboardType(.decimalPad)
                .padding()
                .frame(width: .infinity)
                .font(.system(size: 100))
                .multilineTextAlignment(.center)
                .focused($isTextFieldFocused)
                .onChange(of: amountText) { oldvalue, newValue in
                    if let amount = Double(newValue.replacingOccurrences(of: ",", with: ".")) {
                        expense.amount = amount
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isTextFieldFocused = true
                    }
                }
        }

        HStack{
            CustomButton(text:"Guardar", isValid: isFormValid){
                expensesService.createExpense(expense: expense)
                isPresented = false
                triggerHapticFeedback()
            }

        }
        .padding()
        
    }
    
    func triggerHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)  // Puede ser .success, .warning o .error
    }
}

#Preview {
    let sampleCategory: Category = Category(id: UUID(), name: "Monster", color: "E7575E" , emoji: "💧")
    
    AddExpenseComponent(category: sampleCategory, isPresented: .constant(true))
}
