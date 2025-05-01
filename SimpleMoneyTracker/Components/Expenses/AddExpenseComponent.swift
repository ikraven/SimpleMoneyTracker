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
    @State private var comment: String = ""
    @Binding var isPresented: Bool
    @FocusState private var isTextFieldFocused: Bool
    
    private var expensesService: ExpensesService {
        ExpensesService(modelContext: modelContext)
    }
    
    
    init(expense: Expense? = nil, category: Category, isPresented: Binding<Bool>) {
        self._category = State(initialValue: category)
        if let expense = expense {
            self._expense = State(initialValue: expense)
        } else {
            self._expense = State(initialValue: Expense(amount: 0, date: Date(), category: category))
        }
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
        VStack{
            TextField("EUR", text: $amountText)
                .keyboardType(.decimalPad)
                .padding()
                .font(.system(size: 100))
                .multilineTextAlignment(.center)
                .focused($isTextFieldFocused)
                .onChange(of: amountText) { oldvalue, newValue in
                    if let amount = Double(newValue.replacingOccurrences(of: ",", with: ".")) {
                        expense.amount = amount
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        isTextFieldFocused = true
                    }
                }
            
            HStack{
                Text("Comentario:")
                TextField("",text: $comment)
                    .textFieldStyle(.plain)
                    .onChange(of: comment) { oldvalue, newValue in
                        if !newValue.isEmpty {
                            expense.comment = comment
                        }
                        
                    }
            }
            
            CustomButton(text:"Guardar", isValid: isFormValid){
                expensesService.createOrUpdateExpense(expense: expense)
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

#Preview("Empty Expense") {
    let sampleCategory: Category = Category(id: UUID(), name: "Monster", color: "E7575E" , emoji: "💧")
    
    AddExpenseComponent(category: sampleCategory, isPresented: .constant(true))
}

#Preview("Edit expense") {
    let sampleCategory: Category = PreviewMockData.shared.sampleExpenses[0].category
    let sampleExpense = PreviewMockData.shared.sampleExpenses[0]
    
    AddExpenseComponent(expense: sampleExpense, category: sampleCategory, isPresented: .constant(true))
}
