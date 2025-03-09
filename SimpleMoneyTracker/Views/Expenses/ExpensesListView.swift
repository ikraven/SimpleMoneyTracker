//
//  ExpensesListView.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 3/3/25.
//

import SwiftUI

struct ExpensesListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var expensesList: [Expense] = []
    @State private var searchText = ""
    
    private var expensesService: ExpensesService {
        ExpensesService(modelContext: modelContext)
    }
    
    private var filteredExpenses: [Expense] {
        if searchText.isEmpty {
            return expensesList
        }
        return expensesList.filter { expense in
            expense.category.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(groupExpense(expenses: filteredExpenses)) { group in
                    Section(header: HStack{
                        Text(group.Day.formattedDate())
                        Spacer()
                        Text(group.Total.formatedAmount())
                    }){
                        let dayExpenses = group.Expenses
                        ForEach(dayExpenses){ dayExpense in
                            HStack{
                                CategoryCircleComponent(category: dayExpense.category)
                                    .frame(width: 50)
                                    .padding(.trailing)
                                VStack(alignment: .leading ){
                                    Text(dayExpense.category.name)
                                    Text(dayExpense.creationDate.dayHour())
                                        .font(.subheadline)
                                }
                                
                                Spacer()
                                Text(dayExpense.amount.formatedAmount())
                            }
                        }
                    }
                };
            }
            .searchable(text: $searchText, prompt: "Buscar por categoría")
            .navigationTitle("Gastos")
        }
        .onAppear{
            expensesList = expensesService.getAllExpenses()
        }
    }
    
    
    func groupExpense(expenses: [Expense]) -> [MonthExpenses] {
        // Agrupar por día, ignorando la hora
        let groupedExpenses = Dictionary(grouping: expenses) { expense in
            // Obtener solo la fecha sin la hora
            Calendar.current.startOfDay(for: expense.creationDate)
        }
        
        // Crear los MonthExpenses ordenados por fecha
        return groupedExpenses.map { (date, expenses) in
            let sum = expenses.reduce(0) { $0 + $1.amount }
            return MonthExpenses(Day: date, Expenses: expenses, Total: sum)
        }.sorted { $0.Day > $1.Day } // Ordenar de más reciente a más antiguo
    }
    
}

public class MonthExpenses: Identifiable{
    public var Day: Date
    public var Total: Double
    public var Expenses: [Expense]
    
    init(Day: Date, Expenses: [Expense], Total: Double) {
        self.Day = Day
        self.Expenses = Expenses
        self.Total = Total
    }
}

#Preview {
    
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
      
    return ExpensesListView()
        .modelContainer(testContainer)
    
}
