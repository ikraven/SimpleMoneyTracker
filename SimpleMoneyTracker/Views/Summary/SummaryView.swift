//
//  SummaryView.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 5/2/25.
//

import SwiftUI
import Charts
import SwiftData

struct SummaryView: View {
    @Environment(\.modelContext) private var modelContext
    
    
    private var expensesSummaryService: ExpensesSummaryService {
        ExpensesSummaryService(modelContext: modelContext)
    }
    
    @State private var summaryExpenses: [SummaryExpense] = []
    
    let currentDate: Date = Date()
    
    @State private var isAnimated = false
    @State private var selectedTimeUnit: DateUtils.RangeType = .day // Valor inicial
    @State private var totalAmont: Double = 0
    
    var body: some View {
        
        VStack {
            Picker("Select Time Unit", selection: $selectedTimeUnit){
                ForEach(DateUtils.RangeType.allCases) { timeUnit in
                             Text(timeUnit.rawValue)
                                 .tag(timeUnit) // Asocia cada valor con el picker
                         }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onChange(of: selectedTimeUnit){ oldvalue, newvalue in
                callFunctionForSelectedTimeUnit(value: newvalue)
                print("selected")
            }
            Text(getFormattedRange(rangeType: selectedTimeUnit))
            ZStack {
                VStack {
                    Text("Total:")
                    Text(getTotal(), format:.currency(code: Locale.current.currency?.identifier ?? "EUR"))
                        .frame(alignment: .bottom)
                }
                Chart{
                    ForEach(summaryExpenses) { expense in
                        SectorMark(
                            angle: .value("Monto", expense.amount ),
                            innerRadius: .ratio(0.5) // Ajusta para hacer un "doughnut chart"
                        )
                        .foregroundStyle(expense.category!.getColor())
                        //.opacity(expense.isAnimated ? 1 : 0)
                    }
                }
                .onAppear{
                    Task {
                        summaryExpenses = expensesSummaryService.getSummary(for: Date(), with: .year)
                        print("Datos cargados: \(summaryExpenses.map { "\($0.category?.name ?? ""): \($0.amount)" }.joined(separator: ", "))")
                    }
                }
                //.onAppear(perform: animateChart)
                .frame(height: 300)
                .padding()
            }
            List{
                ForEach(summaryExpenses.sorted(by: { $0.amount > $1.amount } )){ expense in
                    HStack{
                        Circle()
                            .fill(expense.category!.getColor())
                            .frame(width: 20)
                        Text(expense.category!.name)
                        Spacer()
                        Text(expense.formatedAmount())
                    }
                    
                }
            }
        }// ::VStack
    }
    
    func callFunctionForSelectedTimeUnit(value timeUnit: DateUtils.RangeType) {
        summaryExpenses = expensesSummaryService.getSummary(for: Date(), with: timeUnit)
      }
    private func getFormattedRange(rangeType: DateUtils.RangeType) -> String{
        let range =  DateUtils.getFisrtAndLastDate(for: Date(), with: rangeType)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyy"
        switch rangeType {
        case  .day:
            return "\(formatter.string(from: range.0))"
        default:
            return "\(formatter.string(from: range.0)) - \(formatter.string(from: range.1))"
        }
        
    }
    private func getTotal() -> Double{
        return summaryExpenses.reduce(0.0) { $0 + $1.amount }
    }
    private func animateChart() {
       
        
        guard !isAnimated else { return }
        isAnimated = true
        
        $summaryExpenses.enumerated().forEach { index , element in
            let delay = Double(index) * 0.05
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.smooth){
                    element.wrappedValue.isAnimated = true
                }
            }
        }
    }
    
}

#Preview {
    
    let testContainer = try! ModelContainer(for: Expense.self,
                                            configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let testContext = testContainer.mainContext

    let monsterCategory = Category(id: UUID(), name: "Monster", color: "E7575E", emoji: "💧")
    
    let dogFoodCategory = Category(id: UUID(), name: "Dog Food", color: "348ceb", emoji: "💧")
    
    testContainer.mainContext.insert(monsterCategory)
    
    testContainer.mainContext.insert(dogFoodCategory)
    
    let expense = Expense(amount: 2, date: Date(), category: monsterCategory)
    
    testContext.insert(Expense(amount: 2, date: Date(), category: monsterCategory))
    
    testContext.insert(Expense(amount: 2, date: Date(), category: monsterCategory))
                                 
    testContext.insert(Expense(amount: 1.8, date: Date(), category: dogFoodCategory))
    
    let taskService = ExpensesService(modelContext: testContext)
                
    
    return SummaryView()
        .modelContainer(testContainer)

}
