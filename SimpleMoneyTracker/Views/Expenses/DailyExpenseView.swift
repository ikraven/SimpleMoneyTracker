//
//  DailyExpenseView.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 27/1/25.
//

import SwiftUI
import SwiftData

struct DailyExpenseView: View {
    @Environment(\.modelContext) private var modelContext
    
    
    private var expensesService: ExpensesService {
        ExpensesService(modelContext: modelContext)
    }
    
    @State private var expenses: [Expense] = []
    
    @State private var shouldShowMenu = true
    
    @State private var isSheetPresented = false
    
    @State private var currentDate: Date = Date()
    
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button{
                    isSheetPresented.toggle()
                } label:{
                    Image(systemName: "plus")
                        .imageScale(.large)
                }.padding(.trailing)
            }
            
            WeekDateView(weekOffset: 0, selectedDay: $currentDate)
                .frame(height: 100)
                .padding(.bottom)
                .onChange(of: currentDate ){oldValue, newValue in
                    expenses = expensesService.getExpenses(for: currentDate)
                }

            ZStack(alignment: .bottomTrailing) {
                ScrollView{
                    ForEach(expenses) { expense in
                        ExpenseDetailComponent(expense: expense)
                            .contextMenu{
                                Button {
                                    expensesService.deleteExpense(expense)
                                    expenses = expensesService.getExpenses(for: currentDate)
                                } label: {
                                    Label("Eliminar", systemImage: "delete.left")
                                }
                            }
                        
                    }
                }
                Button {
                    isSheetPresented.toggle()
                              } label: {
                                  Image(systemName: "plus")
                                    //Add the following modifiers for a circular button.
                                    .font(.title.weight(.semibold))
                                    .padding()
                                    .background(Color.mainColor)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                              }
                              .padding(.trailing)

            }//:: - Zstack
            Spacer()
            HStack{
                Text("Total:")
                Text(getTotal(), format:.currency(code: Locale.current.currency?.identifier ?? "EUR"))
                    .frame(alignment: .bottom)
            }

        }//:: - Vstac
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            expenses = expensesService.getExpenses(for: currentDate)
        }
        .sheet(isPresented: $isSheetPresented){
            ExpenseCreateSheetView(isPresented: $isSheetPresented)
                .onDisappear{
                    expenses = expensesService.getExpenses(for: currentDate)
                }
        }
        
    }
    
    private func getTotal() -> Double{
        return expenses.reduce(0.0) { $0 + $1.amount }
    }
}

#Preview {
    let testContainer = try! ModelContainer(for: Expense.self,
                                            configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let testContext = testContainer.mainContext

    let monsterCategory = Category(id: UUID(), name: "Monster", color: "E7575E")
    
    let dogFoodCategory = Category(id: UUID(), name: "Dog Food", color: "348ceb")
    
    testContainer.mainContext.insert(monsterCategory)
    
    testContainer.mainContext.insert(dogFoodCategory)
    
    let expense = Expense(amount: 2, date: Date(), category: monsterCategory)
    
    testContext.insert(expense)
    
    testContext.insert(Expense(amount: 1.8, date: Date(), category: dogFoodCategory))
    testContext.insert(Expense(amount: 1.8, date: Date(), category: dogFoodCategory))
    
    testContext.insert(Expense(amount: 1.8, date: Date(), category: dogFoodCategory))
    
    testContext.insert(Expense(amount: 1.8, date: Date(), category: dogFoodCategory))
    
    testContext.insert(Expense(amount: 10, date: Date(), category: monsterCategory))

    testContext.insert(Expense(amount: 1.8, date: Date(), category: dogFoodCategory))
    
    testContext.insert(Expense(amount: 5, date: Date(), category: monsterCategory))

    
    testContext.insert(Expense(amount: 1.8, date: Date(), category: dogFoodCategory))
    
    testContext.insert(Expense(amount: 5, date: Date(), category: monsterCategory))

    
    let taskService = ExpensesService(modelContext: testContext)
                
    
    return DailyExpenseView()
        .modelContainer(testContainer)

}
