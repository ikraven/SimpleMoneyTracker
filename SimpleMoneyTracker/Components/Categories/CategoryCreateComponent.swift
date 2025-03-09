//
//  CategoryCreateComponent.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 27/1/25.
//

import SwiftUI
import SwiftData

struct EmojiCategory {
    let name: String
    let emojis: [String]
    let representativeEmoji: String
}

struct CategoryCreateComponent: View {
    let onClose: () -> Void
    @Environment(\.modelContext) private var modelContext
    
    private var categoryService: CategoryService {
        CategoryService(modelContext: modelContext)
    }
    
    @State private var categoryName: String = ""
    @State private var categoryColor = Color.clear
    @State private var selectedEmoji: String = ""
    @State private var expandedCategory: String? = nil
    @State private var showAllCategories: Bool = false
    @State private var category: Category? = nil
    
    init(category: Category? = nil, onClose: @escaping () -> Void) {
        self.onClose = onClose
        
        // Inicializar los valores por defecto si no hay categoría
        let initialName = category?.name ?? "Nombre Categoría"
        let initialColor = category?.getColor() ?? Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
        let initialEmoji = category?.emoji ?? "🏷️"
        
        // Usar _State para inicializar las propiedades @State
        _categoryName = State(initialValue: initialName)
        _categoryColor = State(initialValue: initialColor)
        _selectedEmoji = State(initialValue: initialEmoji)
        _category = State(initialValue: category)
    }
    
    let selectorColos:  [Color] = [
        .red, .blue, .green, .yellow, .orange, .purple, .pink, .brown,
        .cyan, .mint, .teal, .indigo, .gray, .black, .primary,
        .secondary, Color(.systemPink), Color(.systemBlue), Color(.systemGreen)
    ]
    
    let emojiCategories: [EmojiCategory] = [
        EmojiCategory(name: "Gastos Básicos", emojis: ["🏠", "💡", "💧", "🚰", "🥚", "🌡️", "🧹", "🏦"], representativeEmoji: "🏠"),
        EmojiCategory(name: "Transporte", emojis: ["🚗", "🚌", "✈️", "🚅", "🚲", "⛽️", "🅿️", "🚕"], representativeEmoji: "🚗"),
        EmojiCategory(name: "Alimentación", emojis: ["🍔", "🍕", "🥗", "🥘", "🍜", "🥖", "🥩", "🥑", "🍎", "🥤"], representativeEmoji: "🍔"),
        EmojiCategory(name: "Entretenimiento", emojis: ["🎮", "🎬", "🎵", "🎨", "🎪", "🎭", "🎲", "🎳"], representativeEmoji: "🎮"),
        EmojiCategory(name: "Compras", emojis: ["👕", "👖", "👟", "👜", "💄", "⌚️", "💍", "🎁"], representativeEmoji: "🛍️"),
        EmojiCategory(name: "Salud", emojis: ["💊", "🏥", "🦷", "👓", "🧘‍♀️", "⚕️", "🏋️‍♀️", "🧘‍♂️"], representativeEmoji: "⚕️"),
        EmojiCategory(name: "Educación", emojis: ["📚", "✏️", "💻", "🎓", "📝", "🔬", "🎨", "📐"], representativeEmoji: "📚"),
        EmojiCategory(name: "Otros", emojis: ["🐶", "🌱", "🏖️", "🎪", "💝", "🎯", "🎨"], representativeEmoji: "💝")
    ]
    
    let popularEmojis = ["🏠", "🚗", "🍔", "🎮", "👕", "💊", "📚", "💡", "✈️", "🎵", 
                        "🏋️‍♂️", "🎨", "🐶", "🎁", "🏦", "🚌", "📱", "🎓", "💝", "⚽️"]
    
    var isFormValid: Bool {
        !categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        selectedEmoji != "" &&
        categoryColor != .clear
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .center) {
                Text(category == nil ? "Crear Categoría" : "Editar Categoría")
                    .padding()
                HStack {
                    Text(selectedEmoji)
                        .font(.system(size: 40))
                    Text(categoryName)
                        .foregroundColor(categoryColor)
                        .font(.title)
                }
                .padding()
                CustonTextField(
                    text: $categoryName
                )
                .padding(.leading)
                .padding(.trailing)
            }
            
        }.frame(alignment: .center)
        
        List{
            Section(header: Text("Emoji")) {
                if !showAllCategories {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 10) {
                        ForEach(popularEmojis, id: \.self) { emoji in
                            Text(emoji)
                                .font(.system(size: 30))
                                .frame(width: 44, height: 44)
                                .background(selectedEmoji == emoji ? Color.mainColor.opacity(0.3) : Color.clear)
                                .cornerRadius(8)
                                .onTapGesture {
                                    selectedEmoji = emoji
                                }
                        }
                    }
                    .padding(.vertical, 8)
                    
                    Button(action: {
                        withAnimation {
                            showAllCategories = true
                        }
                    }) {
                        HStack {
                            Text("Ver más emojis")
                                .font(.system(size: 16))
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.blue)
                        .padding(.vertical, 8)
                    }
                } else {
                    Button(action: {
                        withAnimation {
                            showAllCategories = false
                            expandedCategory = nil
                        }
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Volver a emojis populares")
                                .font(.system(size: 16))
                            Spacer()
                        }
                        .foregroundColor(.blue)
                        .padding(.vertical, 8)
                    }
                    
                    ForEach(emojiCategories, id: \.name) { category in
                        VStack(spacing: 0) {
                            HStack {
                                Text(category.representativeEmoji)
                                    .font(.system(size: 30))
                                Text(category.name)
                                    .font(.caption)
                                Spacer()
                                Image(systemName: expandedCategory == category.name ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation {
                                    if expandedCategory == category.name {
                                        expandedCategory = nil
                                    } else {
                                        expandedCategory = category.name
                                    }
                                }
                            }
                            
                            if expandedCategory == category.name {
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 10) {
                                    ForEach(category.emojis, id: \.self) { emoji in
                                        Text(emoji)
                                            .font(.system(size: 30))
                                            .frame(width: 44, height: 44)
                                            .background(selectedEmoji == emoji ? Color.mainColor.opacity(0.3) : Color.clear)
                                            .cornerRadius(8)
                                            .onTapGesture {
                                                selectedEmoji = emoji
                                            }
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                }
            }
            
            Section(header: Text("Color"))
            {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 39))], spacing: 20) {
                    ForEach(selectorColos,id: \.self){ color in
                        VStack{
                            Circle()
                                .fill(color)
                                .frame(width: 25, height: 25)
                                .overlay(
                                        Circle()
                                            .stroke(Color.mainColor, lineWidth: categoryColor == color ? 4 : 0) // Borde en el seleccionado
                                    )
                                .onTapGesture {
                                    categoryColor = color
                                }
                        }.padding(1)
                        
                    }
                }
                VStack{
                    ColorPicker("Selecciona tu color", selection: $categoryColor)
                        .padding(.leading)
                        .padding(.trailing)
                }
            }

        }//: List
        HStack{
            CustomButton(text: "Guardar", isValid: isFormValid, clicked: {
                CreateCategory()
                onClose()
            })
            
        }
        .padding()
    }
    
    private func CreateCategory() -> Void {
        let categoryName = categoryName
        let color = categoryColor.toHex()
        
        if let existingCategory = category {
            // Actualizar categoría existente
            existingCategory.name = categoryName
            existingCategory.color = color
            existingCategory.emoji = selectedEmoji
            _ = categoryService.CreateUpdateCategory(for: existingCategory)
        } else {
            // Crear nueva categoría
            let newCategory = Category(id: UUID(), name: categoryName, color: color, emoji: selectedEmoji)
            _ = categoryService.CreateUpdateCategory(for: newCategory)
        }
    }
    
    
}

#Preview("Nueva categoría") {
    CategoryCreateComponent(onClose: {})
}

#Preview("Categoría existente") {
    let categoryToEdit = Category(id: UUID(), 
                                name: "Prueba Edicion", 
                                color: Color.mint.toHex(), 
                                emoji: "💡")
    CategoryCreateComponent(category: categoryToEdit, onClose: {})
}
