//
//  MonthExpensesChart.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 1/3/25.
//

import SwiftUI
import SwiftData
import Charts

struct MonthExpensesChart: View {
    
    let categories: [CategoryAmmount]
    
    var body: some View {
        if categories.isEmpty {
            Text("No hay datos para mostrar")
                .frame(height: 200)
        } else {
            HStack{
                VStack(alignment: .leading){
                    ForEach(categories) { category in
                        HStack{
                            CategoryCircleComponent(category: category.Category)
                                .frame(width: 25, height: 25)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(category.Category.name)
                                    .font(.footnote)
                                Text(category.TotalAmmount.formatedAmount())
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding()
               
                Chart{
                    ForEach(categories) {data in
                        SectorMark(
                            angle: .value("Monto", data.TotalAmmount ),
                            innerRadius: .ratio(0.618),
                            angularInset: 5.0
                        )
                        .foregroundStyle(data.Category.getColor())
                        .cornerRadius(5)
                    }
                }
                .padding()
                .frame(height: 200)

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground)) // Se adapta a modo claro/oscuro
            .cornerRadius(12)
            .overlay( // Agregamos un borde que será visible en ambos modos
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
            .shadow(radius: 2) // Opcional para un efecto más elegante
        }
    }
    

}

#Preview{
    
    let sample: [CategoryAmmount] = [CategoryAmmount(category: PreviewMockData.shared.monsterCategory, totalAmmount: 33.0),CategoryAmmount(category: PreviewMockData.shared.dogFoodCategory, totalAmmount: 42.0)]
    
    MonthExpensesChart(categories: sample)
}
