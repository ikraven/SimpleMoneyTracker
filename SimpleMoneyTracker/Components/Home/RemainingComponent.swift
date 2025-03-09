//
//  RemainingComponent.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 5/3/25.
//

import SwiftUI

/// Componente para mostrar el restante del límite estipulado
struct RemainingComponent: View {
    let limit: Double
    let expensed: Double
    @State private var showGauge = false  // Para animación

    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Límite mensual")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(limit.formatedAmount())
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Gastado")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(expensed.formatedAmount())
                            .font(.body)
                            .foregroundColor(percentage >= 85 ? .red : .primary)
                    }
                    
                    Divider()
                        .frame(height: 40)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Restante")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text((limit - expensed).formatedAmount())
                            .font(.body)
                            .foregroundColor(.mainColor)
                    }
                }
            }
            .padding(.vertical)
            .padding(.leading)
         
            Spacer()

            Gauge(value: showGauge ? expensed : 0, in: 0...limit) {
            } currentValueLabel: {
                Text("\(percentage)%")
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .gaugeStyle(.accessoryCircular)
            .tint(percentage >= 85 ? Color.red : .mainColor)
            .scaleEffect(1.8)
            .frame(width: 90, height: 90)
            .padding(.trailing)
            .animation(.spring(duration: 1), value: showGauge)
        }
        .onAppear {
            showGauge = true
        }
        .cardStyle()
    }
    
    private var percentage: Int {
        guard limit > 0 else { return 0 }
        return Int((expensed / limit) * 100)
    }
    
}

#Preview("Data") {
    RemainingComponent(limit: 1000.0, expensed: 333.0)
}
#Preview("Empty") {
    RemainingComponent(limit: 0, expensed: 0)
}
