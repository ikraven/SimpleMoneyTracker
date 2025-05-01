//
//  PlanningCardComponent.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 1/5/25.
//

import SwiftUI

struct PlanningCardComponent: View {
    @State var expensePlannning: Planning
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(expensePlannning.PlanningCategory.emoji!)
                            .font(.title2)
                        Text(expensePlannning.PlanningName)
                            .font(.headline)
                    }

            Text("Día \(expensePlannning.dayNumber)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Spacer()

            Text("\(expensePlannning.Ammount, format: .currency(code: "EUR"))")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.primary)
                }
                .padding()
                .frame(height: 120)
                .background(expensePlannning.PlanningCategory.getColor())
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 2)
    }
}

#Preview {
    
    PlanningCardComponent(expensePlannning: PreviewMockData.shared.gymPlanningExpense)
}
