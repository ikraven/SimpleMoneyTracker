//
//  DaysComponent.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 26/1/25.
//

import SwiftUI

struct DaysComponent: View {
    
    
    let date: Date
    @State var isCurrentDate: Bool = false
    @State var isSelected: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Text(date.dayNumber())
                        .font(.headline)
                        .foregroundColor(isSelected ? .primary : .secondary)
                Text(date.dayOfWeek())
                    .font(.subheadline)
                    .foregroundColor(getColor(isCurrentDate: isCurrentDate, isSelected: isSelected))
                    .padding(.bottom,1)
            }
            .frame(width: 35, height: 50)
            .cornerRadius(12) // Esquinas más redondeadas
            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2) // Sombra suave
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    .opacity(isSelected ? 1 : 0)
            )
        }
    }
    func getColor(isCurrentDate: Bool, isSelected: Bool) -> Color {
        switch (isCurrentDate, isSelected) {
        case (true, true): return .mainColor
        case (true, false): return .mainColor
        case (false, true): return .primary
        case (false, false): return .secondary
        }
    }
}

#Preview ("Current OFF")
{

    DaysComponent(date: Date())
}

#Preview ("Current ON")
{
    DaysComponent(date: Date(), isCurrentDate: true)
}

#Preview ("Selected Current OFF")
{

    DaysComponent(date: Date(), isSelected: true)
}

#Preview ("Selected Current ON")
{
    DaysComponent(date: Date(), isCurrentDate: true, isSelected: true)
}
