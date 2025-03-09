//
//  HourDatePicker.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 26/2/25.
//

import SwiftUI

struct HourDatePicker: View {
    @State private var selectedTick: Double
    let onSave: (Double) -> Void
    
    init(initialValue: Double = 720, onSave: @escaping (Double) -> Void) {
        _selectedTick = State(initialValue: initialValue)
        self.onSave = onSave
    }
    
    @State private var selectedHour = 12.0
    @State private var selectedMinute = 30.0
    
    var animatableData: Double {
        get { selectedMinute }
        set { selectedMinute = newValue }
    }
    var body: some View {
        VStack(spacing: 20) {
            Text("Selecciona la hora")
                .font(.headline)
                .padding()
            
            VStack(alignment: .center, spacing: 30) {
        
                HStack{
                    Text(String(format: "%02d", getTickHour(selectedTick)))
                        .font(.system(size: 100, weight: .bold))
                        .fontWeight(.bold)
                    Text(":")
                        .font(.system(size: 100, weight: .bold))
                        .fontWeight(.bold)
                    ZStack {
                        Text(String(format: "%02d", getTickMinute(selectedTick)))
                            .font(.system(size: 100, weight: .bold))
                            .fontWeight(.bold)
                            .contentTransition(.numericText())
                            .animation(.linear, value: selectedTick)
    
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Desliza")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.bottom)
                    TickSlider(
                        value: $selectedTick,
                        range: 0...1440,
                        step: 5,
                        tickCount: 24)
                    
                }
            }
            .padding(.horizontal)
            
            CustomButton(text:"Guardar"){
                onSave(selectedTick)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Asegura que todo el VStack ocupe la pantalla
        
    }
    
    func convertirMinutosAHora(_ minutos: Double) -> String {
        let minutosEnteros = Int(minutos) // Convertimos Double a Int
        let horas = minutosEnteros / 60
        let minutosRestantes = minutosEnteros % 60
        return String(format: "%02d:%02d", horas, minutosRestantes)
    }
    
    func getTickHour(_ minutos: Double) -> Int{
        let minutosEnteros = Int(minutos) // Convertimos Double a Int
        return minutosEnteros / 60
    }
    
    func getTickMinute(_ minutos: Double) -> Int{
        let minutosEnteros = Int(minutos) // Convertimos Double a Int
        return minutosEnteros % 60
    }
}

#Preview {
    HourDatePicker(initialValue: 750.0) { newValue in
        print("Nuevo valor seleccionado: \(newValue)")
    }
}
