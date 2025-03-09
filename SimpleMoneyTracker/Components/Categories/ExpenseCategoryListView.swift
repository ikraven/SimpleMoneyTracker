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
    
    var body: some View {
        NavigationStack {
            VStack{
                List{
                    ForEach(categories){ category in
                        HStack{
                            Circle()
                                .fill(category.getColor())
                                .frame(width: 50)
                                .padding(.trailing)
                            
                            Text(category.name)
                        }
                        .swipeActions{
                            Button("Delete", role: .destructive){
                                modelContext.delete(category)
                            }
                        }
                    }//: List
                    .toolbar{
                        ToolbarItem(placement: .topBarTrailing){
                            Button{
                                //isAlertShowing.toggle()
                            } label:{
                                Image(systemName: "plus")
                                    .imageScale(.large)
                            }
                        }
                    }
                    .overlay{
                        if categories.isEmpty{
                            ContentUnavailableView("Categorías", systemImage: "plus.circle", description: Text("Añade categoráis para poder registar tus gastos"))
                        }
                    }
                }
            }
            
        }
        
    }
}

#Preview ("Content") {
    let container = try! ModelContainer(for: Category.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    container.mainContext.insert(Category(id: UUID(), name: "Monster", color: "E7575E"))
 
    return ExpenseCategoryListView()
        .modelContainer(container)
}

#Preview ("Empty") {
     ExpenseCategoryListView()
        .modelContainer(for: Category.self, inMemory: true)
}
