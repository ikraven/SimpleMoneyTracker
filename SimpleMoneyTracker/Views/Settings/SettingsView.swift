//
//  SettingsView.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 17/2/25.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    //MARK: - Variables
    @Environment(\.modelContext) private var modelContext
    private var expensesService: ExpensesService {
        ExpensesService(modelContext: modelContext)
    }
    
    //MARK: - Notificaciones
    @State var summaryNotification: Bool = true
    @AppStorage("notificationsTime") private var notiTime: Double = 720
    @State var showSheet: Bool = false
    @State var showLimitSheet: Bool = false
    @State var showRecalculateSheet: Bool = false
    @State var showAggregateData: Bool = false
    @State var expenseLimit: Double = 0
    var body: some View {
        List{
            Section(header: Text("Notificaciones"), footer: HStack{
                Text("Toca en la notificación para cambiar el horario")
            }){
                VStack(alignment: .leading, spacing: 4) {
                    Toggle(isOn: $summaryNotification) {
                        Text("Resumen diario")
                    }
                    
                    if summaryNotification {
                        Text(convertirMinutosAHora(notiTime))
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                            .padding(.leading, 4)
                    }
                }
                .onTapGesture {
                    showSheet.toggle()
                }
            }//: SECTION
            Section(
                            footer: HStack{
                                Spacer()
                                Text("Made wiht ❤️ from Zaragoza.")
                                Spacer()
                            }.padding(.vertical, 8)
                            
            ){
                HStack{
                    Text("Límite mensual")
                    Spacer()
                    Text(expenseLimit.formatedAmount())
                }
                .onTapGesture {
                    showLimitSheet.toggle()
                }
                #if DEBUG
                HStack{
                    Text("Recalculo de contadores")
                }
                .onTapGesture {
                    showRecalculateSheet.toggle()
                    _ = expensesService.recalculateExpensesAgregate()
                    
                }
                
                HStack{
                    Text("Mostrar Totales")
                }
                .onTapGesture {
                    showAggregateData.toggle()
                }
                #endif
            }
        }//: LIST
        .sheet(isPresented: $showSheet){
            VStack{
                HourDatePicker(initialValue: notiTime) { newValue in
                    notiTime = newValue
                    showSheet = false
                }
                .presentationCornerRadius(50)
                .presentationSizing(.form)
            }
            //.presentationBackground(.mint)
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
            .padding()

        }
        .sheet(isPresented: $showLimitSheet){
            VStack{
                LimitAssingComponent{ newLimit in
                    editLimit(newLimit: newLimit)
                    expenseLimit = getLimit()?.limit ?? 0
                    showLimitSheet = false
                }
                .presentationCornerRadius(50)
                .presentationSizing(.form)
            }
            //.presentationBackground(.mint)
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
            .padding()

        }
        .sheet(isPresented: $showRecalculateSheet){
            ProgressView()
        }
        .sheet(isPresented: $showAggregateData){
            let data = expensesService.getAllAgregates()
            VStack{
                ScrollView{
                    ForEach(data){day in
                        HStack{
                            Text("\(day.Month)")
                            Spacer()
                            Text(day.Ammount.formatedAmount())
                        }
                    }
                }

            }
        }
    }
    func convertirMinutosAHora(_ minutos: Double) -> String {
        let minutosEnteros = Int(minutos) // Convertimos Double a Int
        let horas = minutosEnteros / 60
        let minutosRestantes = minutosEnteros % 60
        return String(format: "%02d:%02d", horas, minutosRestantes)
    }
    private func getLimit() -> Account? {
        let descriptor = FetchDescriptor<Account>()
        do {
            let accounts = try modelContext.fetch(descriptor)
            return accounts.first

        } catch {
            print("Error al crear cuenta por defecto: \(error)")
        }
        return nil
    }
    private func editLimit(newLimit: Double) {
        if let limit = getLimit(){
            limit.limit = newLimit
            do
            {
                try modelContext.save()
            }catch{
                print("Error al editar limite: \(error)")
            }
            
            
        }
    }
    
}

#Preview {
    SettingsView()
}
