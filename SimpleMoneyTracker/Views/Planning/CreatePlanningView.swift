//
//  CreatePlanningView.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 3/5/25.
//

import SwiftUI

struct CreatePlanningView: View {
    @Environment(\.modelContext) private var modelContext
    
    private var cateagoryService: CategoryService {
        CategoryService(modelContext: modelContext)
    }
    
    @State private var categories: [Category] = []
    
    @State private var planningName: String = "Nombre Planificado"
    @State private var selectedCategoty: Category?
    
    @State private var selectedPeriod: Planning.Period = .monthly
    
    
    var body: some View {
            VStack(alignment: .center) {
                Text("Crear gasto planificado")
                    .padding()
                HStack {
                    Text(selectedCategoty?.emoji ?? "")
                        .font(.system(size: 40))
                    Text(planningName)
                        .foregroundColor(selectedCategoty?.getColor() ?? Color.main)
                        .font(.title)
                }
                .padding()
                CustonTextField(
                    text: $planningName
                )
                .padding(.leading)
                .padding(.trailing)
                List{
                    Section(header: Text("Categoría")){
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 10){
                            ForEach(categories, id: \.self){
                                category in
                                VStack{
                                    ZStack {
                                        Circle()
                                            .fill(category.getColor())
                                            .frame(width: 60, height: 60)
                                        Text(category.emoji ?? "💶")
                                            .font(.system(size: 40))
                                    }
                                    Text(category.name)
                                        .font(.caption)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .frame(width: 80, height: 100)
                                .padding(10)
                            }
                        }
                    }
                    Section(header: Text("Periodo")){
                        
                        Picker("Select Time Unit", selection: $selectedPeriod){
                            ForEach(Planning.Period.allCases) { periodType in
                                switch periodType{
                                case .monthly:
                                    Text("Mensual")
                                        .tag("Mensual") // Asocia cada valor con el picker
                                case .weekly:
                                    Text("Semanal")
                                        .tag("tSemanal") // Asocia cada valor con el picker
                                case .yearly:
                                    Text("Anual")
                                        .tag("Anual") // Asocia cada valor con el picker
                                }
                                        
                                     }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        
                    }
                }
            }
            .onAppear(){
                categories = cateagoryService.GetAllCategoties()
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
    
    let homeCategory = Category(id: UUID(), name: "Casa", color: Color.mint.toHex(), emoji: "🏡")
    
    testContainer.mainContext.insert(homeCategory)
    
    let gymCategory = Category(id: UUID(), name: "Gym", color: Color.red.toHex(), emoji: "🏋️")
    
    testContainer.mainContext.insert(gymCategory)
    
    let foodCategory = Category(id: UUID(), name: "Food", color: Color.clear.toHex(), emoji: "🥗")
    
    testContainer.mainContext.insert(foodCategory)
    
    let gamesCategory = Category(id: UUID(), name: "Games", color: Color.gray.toHex(), emoji: "🎮")
    
    testContainer.mainContext.insert(gamesCategory)
      
    return CreatePlanningView()
        .modelContainer(testContainer)

}
