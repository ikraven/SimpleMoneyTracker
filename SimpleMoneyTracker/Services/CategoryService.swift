//
//  CategoryService.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 2/3/25.
//
import SwiftData
import Foundation


/// Servicio de categorías
public class CategoryService{
    let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func GetAllCategoties() -> [Category]{
        return (try? modelContext.fetch(FetchDescriptor<Category>())) ?? []
    }
    func CreateUpdateCategory(for category: Category) -> Bool{
        do {
            let categoryId = category.id
            let descriptor = FetchDescriptor<Category>(
                predicate: #Predicate<Category> { cat in
                    cat.id == categoryId
                }
            )
            
            let dbCategory = try modelContext.fetch(descriptor).first
            
            if let existingCategory = dbCategory {
                existingCategory.name = category.name
                existingCategory.emoji = category.emoji
                existingCategory.color = category.color
                
                try modelContext.save()
                return true
            } else {
                modelContext.insert(category)
                return true
            }
        } catch {
            print("Error managing Category: \(error)")
            return false
        }
    }
    
}
