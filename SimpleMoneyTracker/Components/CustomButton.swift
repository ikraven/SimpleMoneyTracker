//
//  CustomButton.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 27/2/25.
//

import SwiftUI

struct CustomButton: View {
    var text: String
    var isValid: Bool = true /// valor por defecto true para mantener compatibilidad
    var clicked: (() -> Void) /// use closure for callback
   
    
    var body: some View {
        Button(action: clicked) { /// call the closure here
            HStack {
                Spacer() // Añade espacio al inicio
                Text(text) /// your text
                Spacer() // Añade espacio al final
            }
            .foregroundColor(isValid ? Color.mainColor : Color.gray)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
        }
        .disabled(!isValid)
    }
}

#Preview {
    VStack {
        CustomButton(text: "Botón Activo", clicked: {})
        CustomButton(text: "Botón Inactivo", isValid: false, clicked: {})
    }
}
