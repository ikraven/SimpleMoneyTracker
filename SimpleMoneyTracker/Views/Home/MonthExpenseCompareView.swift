//
//  MonthExpenseCompareView.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 15/3/25.
//

import SwiftUI
import Charts
import SwiftData

struct MonthExpenseCompareView: View {
        var body: some View {
        MonthExpenseCompareViewContent()
    }
}

private struct MonthExpenseCompareViewContent: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        MonthExpenseCompareViewContainter(modelContext: modelContext)
    }
}

struct MonthExpenseCompareViewContainter: View {
 
    @StateObject private var viewModel: ExpenseComparisonViewModel
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: ExpenseComparisonViewModel(modelContext: modelContext))
    }
    
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Cargando datos...")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
                Button("Reintentar") {
                    Task {
                        await viewModel.loadData()
                    }
                }
            } else {
                Text("Comparativa de Gastos")
                    .font(.title)
                    .padding()
                
                // Gráfico de comparación
                Chart {
                    ForEach(viewModel.comparisonData) { item in
                        BarMark(
                            x: .value("Categoría", item.category),
                            y: .value("Mes Actual", item.currentMonthAmount)
                        )
                        .foregroundStyle(.blue)
                        
                        BarMark(
                            x: .value("Categoría", item.category),
                            y: .value("Mes Anterior", item.previousMonthAmount)
                        )
                        .foregroundStyle(.gray)
                    }
                }
                .frame(height: 300)
                .padding()
                
                // Lista de comparaciones
                List(viewModel.comparisonData) { item in
                    VStack(alignment: .leading) {
                        Text(item.category)
                            .font(.headline)
                        
                        HStack {
                            Text("Actual: \(item.currentMonthAmount, specifier: "%.2f") €")
                            Spacer()
                            Text("Anterior: \(item.previousMonthAmount, specifier: "%.2f") €")
                        }
                        .font(.subheadline)
                        
                        HStack {
                            Text("Diferencia: \(item.difference, specifier: "%.2f") €")
                            Spacer()
                            Text("\(item.percentChange, specifier: "%.1f")%")
                                .foregroundColor(item.difference < 0 ? .green : .red)
                        }
                        .font(.subheadline)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadData()
            }
        }
        .navigationTitle("Comparativa Mensual")
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
     return MonthExpenseCompareView()
        .modelContainer(testContainer)
}
