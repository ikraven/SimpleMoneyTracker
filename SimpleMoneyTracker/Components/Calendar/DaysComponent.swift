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
                Text(date.dayOfWeek())
                    .font(.subheadline)
                    .padding(.bottom)
                ZStack{
                        Circle()
                            .fill(isCurrentDate ? Color.mainColor : .primary)
                            .frame(width: 45)
                            .opacity(isSelected ? 1 : 0)
                    Text(date.dayNumber())
                        .font(.headline)
                        .foregroundColor(getColor(isCurrentDate: isCurrentDate, isSelected: isSelected))
                }
                    
            }
        }
    }
    func getColor(isCurrentDate: Bool, isSelected: Bool) -> Color {
        switch (isCurrentDate, isSelected) {
        case (true, true): return .primary
        case (true, false): return .mainColor
        case (false, true): return Color(UIColor.systemBackground)
        case (false, false): return .primary
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
