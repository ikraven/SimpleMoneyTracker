import SwiftUI

struct TickSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let tickCount: Int
    @State private var selectedIndex: Double = 0
    @State private var oldValue: Double = 0
    @State private var offset: CGFloat = 0
        
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
       
                
                // Contenedor de ticks deslizable
                HStack(spacing: 0) {
                    ForEach(0..<tickCount , id: \.self) { index in
                        VStack(spacing: 4) {
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 2, height: getTickHeight(for: index))
                                .cornerRadius(20)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedIndex)
                        }
                        if index < tickCount - 1 {
                            Spacer()
                        }
                    }
                }
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            let newOffset = gesture.translation.width
                            let maxOffset = geometry.size.width / 2
                            let minOffset = -geometry.size.width / 2
                            oldValue = value
                            // Limitar el desplazamiento
                            offset = min(maxOffset, max(minOffset, newOffset))
                            
                            // Calcular el valor basado en el offset
                            let ratio = -offset / geometry.size.width
                            let totalRange = range.upperBound - range.lowerBound
                            let newValue = (totalRange * ratio) + (range.upperBound + range.lowerBound) / 2
                            let steppedValue = round(newValue / step) * step
                            value = min(max(range.lowerBound, steppedValue), range.upperBound)
                            
                            //Calcular en qué indice estamos
                            let tickNewValue = (Double(tickCount) * ratio) + (Double(tickCount)) / 2
                            
                            selectedIndex = tickNewValue
                            
                            if(oldValue != value){
                                triggerHapticFeedback()
                            }
                        }
                )
                // Círculo fijo del slider
                Rectangle()
                    .fill(Color.mainColor)
                    .frame(width: 2, height: 200)
                    .position(x: geometry.size.width / 2, y: 14)
                    .cornerRadius(20)
                    
            }
            .frame(height: 40)
            .clipped()
            .onAppear{
                selectedIndex = Double(tickCount) / 2.0
            }
        }
    }
    func triggerHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    private func getTickHeight(for index: Int) -> CGFloat {
        let currentIndex = Int(selectedIndex)
        let distance = abs(currentIndex - index)
        
        if distance == 0 {
            return 20 // Altura máxima para el tick seleccionado
        } else {
            let minHeight: CGFloat = 10
            let maxHeight: CGFloat = 20
            let heightDifference = maxHeight - minHeight
            let factor = CGFloat(distance) / 3 // Ajusta este valor para controlar la velocidad de la transición
            
            return max(minHeight, maxHeight - (heightDifference * factor))
        }
    }
}


#Preview {
    @Previewable @State var selectedMinute = 15.0

    VStack{
        Spacer()
        Divider()
        TickSlider(
            value: $selectedMinute,
            range: 0...1440,
            step: 1,
            tickCount: 24
        )
    }

}
