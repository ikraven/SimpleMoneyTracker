//
//  CategorySelectorComponent.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 29/1/25.
//

import SwiftUI
import SwiftData

struct CategorySelectorComponent: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var categories: [Category]
    var onCategorySelected: (Category) -> Void
    
    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 20) {
                ForEach(categories){ category in
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
                    .onTapGesture {
                        onCategorySelected(category)
                    }
                }
            }
        }
    }
}

#Preview ("Content") {
    let container = try! ModelContainer(for: Category.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    for i in 0...25{
        container.mainContext.insert(Category(id: UUID(), name: "Monster", color: "E7575E", emoji: "⚡️"))
        container.mainContext.insert(Category(id: UUID(), name: "VERY LONG NAME", color: Color.mint.toHex(), emoji: "💧"))
    }
   

    return CategorySelectorComponent(onCategorySelected: {_ in })
        .modelContainer(container)
}

#Preview {
    CategorySelectorComponent(onCategorySelected: {_ in })
        .modelContainer(for: Category.self, inMemory: true)
}
