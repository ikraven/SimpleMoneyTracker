//
//  ExpenseCategoryListView.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 27/1/25.
//

import SwiftUI
import SwiftData

struct ExpenseCategoryListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var categories: [Category]
    @State private var isSheetPresented = false
    
    var body: some View {
        NavigationStack {
            VStack{
                List(categories){ category in
                    NavigationLink(destination: CategoryDetailView(category: category)){
                        HStack{
                            ZStack{
                                Circle()
                                    .fill(category.getColor())
                                    .frame(width: 50)
                                Text(category.emoji)
                            }
                            .padding(.trailing)
                          
                            
                            Text(category.name)
                        }
                        .swipeActions{
                            Button("Delete", role: .destructive){
                                modelContext.delete(category)
                            }
                        }
                    }
                }//: List
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing){
                        Button{
                            isSheetPresented.toggle()
                        } label:{
                            Image(systemName: "plus")
                                .imageScale(.large)
                        }
                    }
                }
            }//: VStack
            
        }//: NavigationStack
        .sheet(isPresented: $isSheetPresented){
            CategoryCreateComponent{
                isSheetPresented.toggle()
            }
        }
        .overlay{
            if categories.isEmpty{
                ContentUnavailableView("Categorías", systemImage: "plus.circle", description: Text("Añade categoráis para poder registar tus gastos"))
                    .onTapGesture
                {
                    isSheetPresented.toggle()
                }
            }
        }
    }
}

#Preview ("Content") {
    let container = try! ModelContainer(for: Category.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    container.mainContext.insert(PreviewMockData.shared.dogFoodCategory)
    container.mainContext.insert(PreviewMockData.shared.monsterCategory)
    return ExpenseCategoryListView()
        .modelContainer(container)
}

#Preview ("Empty") {
     ExpenseCategoryListView()
        .modelContainer(for: Category.self, inMemory: true)
}
