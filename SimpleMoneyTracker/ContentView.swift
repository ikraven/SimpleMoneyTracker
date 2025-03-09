//
//  ContentView.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 22/1/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    //@Environment(\.modelContext) private var modelContext
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true
    @State private var selectedTab = 0
    var body: some View {
        ZStack{
            TabView(selection: $selectedTab) {
                Group{
                    HomeView()
                    .tabItem {
                                        Label("Inicio", systemImage: "house.fill")
                                    }
                    .tag(0)
                    DailyExpenseView()
                        .tabItem{
                            Label("Tendencias", systemImage: "chart.line.uptrend.xyaxis")
                        }
                        .tag(1)
                    ExpenseCategoryListView()
                        .tabItem{
                            Label("Categorías", systemImage: "list.bullet")
                        }
                        .tag(2)
                    ExpensesListView()
                        .tabItem{
                            Label("Ajustes", systemImage: "gearshape")
                        }
                        .tag(4)
                    SettingsView()
                        .tabItem{
                            Label("Ajustes", systemImage: "gearshape")
                        }
                        .tag(5)
                }
                .toolbarBackground(.thinMaterial, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)

            }
            
            .animation(.bouncy, value: selectedTab)
            .accentColor(Color.mainColor) // Cambia el color de los íconos seleccionados
            .fullScreenCover(isPresented: $isFirstLaunch){
                LandingView()
                    .onTapGesture{
                        isFirstLaunch.toggle()
                    }
      
            }
        }
                
    }
}

#Preview {

    ContentView()
}
