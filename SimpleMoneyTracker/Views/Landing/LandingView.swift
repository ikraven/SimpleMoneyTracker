//
//  LandingView.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 18/2/25.
//

import SwiftUI

struct LandingView: View {

    //MARK: - Variables
    //MARK: - Categorias Fake
    let foodCategory: Category = Category(id: UUID(), name: "Comida", color: Color.green.toHex(), emoji: "💧")
    let clothCatgory: Category = Category(id: UUID(), name: "Ropa", color: Color.orange.toHex(), emoji: "💧")
    //MARK: - Gastos Fake
    let foodExpense: Expense = Expense(amount: 13, date: Date(), category: Category(id: UUID(), name: "Comida", color: Color.green.toHex(), emoji: "💧"))
    let clothExpense: Expense = Expense(amount: 50.4, date: Date(), category: Category(id: UUID(), name: "Ropa", color: Color.orange.toHex(), emoji: "💧"))
    
    var body: some View {
        ZStack {
            VStack{
                CurrencyAnimationComponent(scrollText: "€")
                CurrencyAnimationComponent(inverted: true, scrollText: "€")
                CurrencyAnimationComponent(scrollText: "€")
                CurrencyAnimationComponent(inverted: true, scrollText: "€")
                CurrencyAnimationComponent(scrollText: "€")
            }
            
            VStack{
                
            }
            
            VStack {
                Spacer()
                ExpenseDetailComponent(expense: foodExpense)
                ExpenseDetailComponent(expense: clothExpense)
                Spacer()
                // Sección con fondo que empieza sólido y se difumina
                VStack {
                    Text("Bienvenido a")
                        .font(.system(size: 20, weight: .bold, design: .default))
                                            .foregroundStyle(.secondary)
                    Text("Simple Money Tracker")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    Text("Nuestra app está diseñada para ayudarte a gestionar tus gastos de manera sencilla y clara. Registra tus gastos, asigna categorías y visualiza tus finanzas con gráficos fáciles de entender. Con Easy Money Tracker, tomar el control de tu dinero es más simple que nunca.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    Button("Continuar", action: {
                                   // Acción cuando el usuario toca algo en la pantalla
                                   // Puedes cerrar la pantalla de bienvenida de manera manual si lo deseas
                               })
                    .padding()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    ZStack {
                        // Fondo con RegularMaterial
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.ultraThinMaterial)
                            .mask {
                                VStack(spacing: 0) {
                                    LinearGradient(
                                        colors: [
                                            Color.black.opacity(1),
                                            Color.black.opacity(0),
                                        ],
                                        startPoint: .bottom,
                                        endPoint: .top
                                    )
                                    Rectangle()
                                }
                            }
                    }
                )
                
                
                
            }//:: - Vstack
        }
        .ignoresSafeArea()
    }
}



#Preview {
    LandingView()
}
