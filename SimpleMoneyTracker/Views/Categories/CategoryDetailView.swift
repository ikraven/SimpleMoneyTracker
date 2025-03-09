//
//  CategoryDetailView.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 22/2/25.
//

import SwiftUI
import Charts

struct CategoryDetailView: View {
    //MARK: - PROPERTIES
    @State var category: Category
    @State var today: Date = Date()
    @Environment(\.modelContext) private var modelContext
    @State var total: Double = 0
    
    
    
    private var expensesSummaryService: ExpensesSummaryService {
        ExpensesSummaryService(modelContext: modelContext)
    }
    
    @State private var monthExpenses: [DateSummaryExpense] = []
    
    var body: some View {
        List {
            HStack{
                CategoryCircleComponent(category: category)
                    .frame(width: 50)
                Spacer()
                Text(category.name)
            }
            HStack{
                Text("Total gastado:")
                Spacer()
                Text(expensesSummaryService.getTotalForCategory(for: category.id), format:.currency(code: Locale.current.currency?.identifier ?? "EUR"))
            }
            Section(header: Text("Últimos 12 meses")){
              
                Chart(monthExpenses) { data in
                    BarMark(
                        x: .value("Date", data.expenseDate, unit: .month),
                        y: .value("Views", data.amount)
                    )
                    .foregroundStyle(category.getColor())
                }
                .aspectRatio(1, contentMode: .fit)
            }
           
        }//:: List
        .onAppear(){
            monthExpenses =  expensesSummaryService.getDatesSummary(for: category.id)
        }
    }
}

#Preview {
    
    let testContainer = PreviewMockData.shared.testContainer
    
    let monsterCategory = PreviewMockData.shared.monsterCategory
    
    let dogFoodCategory = PreviewMockData.shared.dogFoodCategory
    
    testContainer.mainContext.insert(monsterCategory)
    
    testContainer.mainContext.insert(dogFoodCategory)
    
    let arrayExpenses = PreviewMockData.shared.sampleExpenses

    for expense in arrayExpenses{
        testContainer.mainContext.insert(expense)
    }
    
    return CategoryDetailView(category:  PreviewMockData.shared.monsterCategory)
        .modelContainer(testContainer)
}
