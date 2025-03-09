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
    @State private var isEditSheetPresented = false
    @State private var categoryToEdit: Category? = nil
    
    enum SheetType: Identifiable {
        case create
        case edit(Category)
        
        var id: String {
            switch self {
            case .create:
                return "create"
            case .edit(let category):
                return "edit_\(category.id)"
            }
        }
    }

    @State private var activeSheet: SheetType?
    
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
                                Text(category.emoji ?? "💶")
                            }
                            .padding(.trailing)
                          
                            
                            Text(category.name)
                        }
                        .swipeActions{
                            Button("Delete", role: .destructive){
                                modelContext.delete(category)
                            }
                            Button("Edit"){
                                activeSheet = .edit(category)
                            }
                            .tint(.blue)
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
        .sheet(item: $activeSheet) { sheetType in
            switch sheetType {
            case .create:
                CategoryCreateComponent {
                    activeSheet = nil
                }
            case .edit(let category):
                CategoryCreateComponent(category: category) {
                    activeSheet = nil
                }
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
