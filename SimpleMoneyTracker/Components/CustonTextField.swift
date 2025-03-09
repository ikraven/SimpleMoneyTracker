//
//  CustonTextField.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 23/2/25.
//

import SwiftUI

struct CustonTextField: View {
    @State private var placeHolderText: String = "Texto..."
    @Binding var text: String
    @State private var localText: String = ""

    var body: some View {
        HStack {
            TextField(placeHolderText, text: $localText)
                .padding(1)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .onAppear {
                      localText = text  // Sincroniza el estado inicial
                  }
                  .onChange(of: localText) {oldvalue,  newValue in
                      text = newValue // Actualiza el binding
                  }

            if !localText.isEmpty {
                Button(action: {
                    text = ""
                    localText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    CustonTextField(text: .constant(""))
        .padding()
}
