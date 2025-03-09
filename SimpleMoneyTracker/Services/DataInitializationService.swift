//
//  DataInitializationService.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 5/3/25.
//

import Foundation
import SwiftData

/// Servicio encargado de inicializar datos por defecto en la aplicación
public class DataInitializationService {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    /// Inicializa todos los datos por defecto necesarios
    func initializeDefaultData() {
        initializeDefaultAccount()
        // Aquí puedes agregar más inicializaciones en el futuro
    }
    
    /// Inicializa la cuenta por defecto si no existe
    private func initializeDefaultAccount() {
        let descriptor = FetchDescriptor<Account>()
        
        do {
            let accounts = try modelContext.fetch(descriptor)
            if accounts.isEmpty {
                let defaultAccount = Account(
                    id: UUID(),
                    limit: 1000.0,
                    remaining: 1000.0,
                    name: "Cuenta Principal"
                )
                modelContext.insert(defaultAccount)
                print("Default Accnount Data Initialized")
                try modelContext.save()
            }
        } catch {
            print("Error al crear cuenta por defecto: \(error)")
        }
    }
} 
