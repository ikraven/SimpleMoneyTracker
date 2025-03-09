//
//  CurrencyAnimationComponent.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 18/2/25.
//

import SwiftUI

struct CurrencyAnimationComponent: View {
    @State var xOffset: CGFloat = 0
    @State var inverted: Bool = false
    @State var scrollText: String
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size.width / 4
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ColorView(size: size, text: scrollText)
                    ColorView(size: size, text: scrollText)
                    ColorView(size: size, text: scrollText)
                    ColorView(size: size, text: scrollText)
                    //Repeeat
                    ColorView(size: size, text: scrollText)
                    ColorView(size: size, text: scrollText)
                    ColorView(size: size, text: scrollText)
                    ColorView(size: size, text: scrollText)
                }
                .offset(x: xOffset, y: 0)
                .onAppear
                {
                    animateScroll(size: size * 4)
                }
            }
        }
    }
    private func change(size: CGFloat){
        xOffset = -size
    }
    private func animateScroll(size: CGFloat) {
        if(inverted){
            xOffset = -size
        }
        
        withAnimation(.linear(duration: inverted ? 3 : 6).repeatForever(autoreverses: false)) {
            xOffset = inverted ? -size / 2 : -size
        }
        print("Inverted-\(inverted)")
        print("xOffset: \(xOffset)")
        print("size: \(size)")
    }
    
}
struct ColorView: View {
    var size: CGFloat
    @State var text: String = "€"
    
    var body: some View {
            VStack{
                Text(text)
                    .foregroundColor(.mainColor)
                    .font(.system(size: 80))
                    .shadow(color: Color.mainColor.opacity(0.6), radius: 10, x: 0, y: 0) // Glow
            }.frame(width: size, height: size, alignment: .center)
        
    }
}

#Preview {
    CurrencyAnimationComponent(scrollText: "$")
    CurrencyAnimationComponent(inverted: true, scrollText: "$")
}

