//
//  CategoryCircleComponent.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 3/3/25.
//

import SwiftUI

struct CategoryCircleComponent: View {
    @State var category: Category
    
    var body: some View {
        ZStack{
            Circle()
                .fill(category.getColor())
            Text(category.emoji ?? "💶")
        }
    }
}

#Preview {
    
    CategoryCircleComponent(category: PreviewMockData.shared.monsterCategory)
}
