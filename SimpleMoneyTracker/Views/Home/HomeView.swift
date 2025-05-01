//
//  TrendView.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 23/2/25.
//

import SwiftUI
import SwiftData
import Charts

struct HomeView: View {
    //MARK: - Variables
    let currentDate: Date = Date()
    @State var totalAmmount: Double = 0
    
    var body: some View {
        HomeViewContent()
    }
}

private struct HomeViewContent: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        HomeViewContainer(modelContext: modelContext)
    }
}

private struct HomeViewContainer: View {
    @StateObject private var viewModel: HomeViewModel
    let currentDate: Date = Date()
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            Text("\(currentDate.monthText()) \(currentDate.yearText())")
                                .font(.largeTitle)
                                .bold()
                            Text("1-\(currentDate.dayNumber())")
                           
                            RemainingComponent(
                                limit: viewModel.limit,
                                expensed: viewModel.currentMonthExpense
                            )
                            .padding(.bottom)
                            
                            NavigationLink(destination: MonthExpenseCompareView()){
                                TotalMonthExpenseComponent(
                                    currentDate: Date(),
                                    currentExpense: viewModel.currentMonthExpense,
                                    pastExpense: viewModel.previousMonthExpense
                                )
                                .padding(.bottom)
                            }.buttonStyle(PlainButtonStyle())
                            
                            
                            MonthExpensesChart(categories: Array(viewModel.categoryAmmount.prefix(4)))
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Home")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // Acción del botón
                    } label: {
                        Image(systemName: "gear")
                            .imageScale(.large)
                    }
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewModel.loadData()
        }
    }
}


#Preview {
    
    
    let testContainer = PreviewMockData.shared.testContainer
    
    let testContext = testContainer.mainContext

    let monsterCategory = PreviewMockData.shared.monsterCategory
    
    let dogFoodCategory = PreviewMockData.shared.dogFoodCategory
    
    testContainer.mainContext.insert(monsterCategory)
    
    testContainer.mainContext.insert(dogFoodCategory)
    
    testContext.insert(Account(id: UUID(), limit: 1000.0, remaining: 1000.0, name: "Sample"))
    

    for expense in PreviewMockData.shared.sampleExpenses{
        testContext.insert(expense)
    }
      
    return HomeView()
        .modelContainer(testContainer)
    
    //HomeView()
}
