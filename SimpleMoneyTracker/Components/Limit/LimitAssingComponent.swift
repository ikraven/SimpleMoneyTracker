//
//  LimitAssingComponent.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 5/3/25.
//

import SwiftUI

struct LimitAssingComponent: View {
    @State private var selectedAmmount: Double
    @State private var isEditing: Bool = false
    @State private var textInput: String = ""
    let onSave: (Double) -> Void
    
    init(initialValue: Double = 720, onSave: @escaping (Double) -> Void) {
        _selectedAmmount = State(initialValue: initialValue)
        self.onSave = onSave
    }
    
    var body: some View {
        VStack{
            Text("Selecciona un límite")
                .font(.headline)
                .padding()
            if isEditing {
                TextField("", text: $textInput)
                    .font(.system(size: 100, weight: .bold))
                    .foregroundStyle(.main)
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                    .frame(maxWidth: .infinity)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .padding()
                    .onAppear {
                        textInput = String(format: "%.0f", selectedAmmount)
                    }
                    .onSubmit {
                        if let newValue = Double(textInput) {
                            selectedAmmount = newValue
                        }
                        isEditing = false
                    }
            } else {
                Text(selectedAmmount.formatedAmount(showDecimals: false))
                    .font(.system(size: 100, weight: .bold))
                    .fontWeight(.bold)
                    .foregroundStyle(.main)
                    .contentTransition(.numericText())
                    .animation(.linear, value: selectedAmmount)
                    .frame(maxWidth: .infinity)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .padding()
                    .onTapGesture {
                        isEditing = true
                    }
            }
            
            VStack{
                Text("Desliza")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom)
                TickSlider(
                    value: $selectedAmmount,
                    range: 0...3000,
                    step: 100,
                    tickCount: 24)
                
                CustomButton(text:"Guardar"){
                    onSave(selectedAmmount)
                }
                
            }.padding()
        }//:: - Vstack
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Asegura que todo el VStack ocupe la pantalla
        

    }
}

#Preview {
    LimitAssingComponent(){ _ in
        
    }
}
