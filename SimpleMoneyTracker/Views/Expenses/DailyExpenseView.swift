//
//  DailyExpenseView.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 27/1/25.
//

import SwiftUI
import SwiftData
import TipKit


struct DailyExpenseView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("isFirstLaunch") private var isFirstLaunch = false
    
    private var expensesService: ExpensesService {
        ExpensesService(modelContext: modelContext)
    }
    
    private let calendar = Calendar.current
    
    @State private var expenses: [Expense] = []
    
    @State private var shouldShowMenu = true
    
    @State private var isSheetPresented = false
    
    @State private var currentDate: Date = Date()
    
    @State private var showMonth = false
    
    // Variable para editar
    @State private var editExpense: Expense? = nil
    
    // Separamos las variables de estado
        @GestureState private var dragTranslation: CGFloat = 0 // Para el arrastre en tiempo real
        @State private var dragOffsetAmount: CGFloat = 0     // Para el offset final del ZStack
        @State private var contentOffset: CGFloat = 0        // Para el offset del ScrollView
        @State private var rectangleFrame: CGRect = .zero    // Marco del Rectangle
    
    let buttonTip = ButtonTip()
    
    func setupTips() {
      do {
        try Tips.configure([
          .displayFrequency(.immediate)
        ])
      } catch {
        print("Error initializing TipKit \(error.localizedDescription)")
      }
    }
    
    init(){
        setupTips()
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                HStack{
                    Text("\(currentDate.monthText()) \(currentDate.yearText())")
                        .padding(.leading)
                        .bold()
                    Spacer()
                    Button{
                        isFirstLaunch.toggle()
                    } label:{
                        Image(systemName: "gear")
                            .imageScale(.large)
                    }.padding(.trailing)
                }
                

                ZStack {
                    if showMonth {
                        MonthView(date: currentDate, selectedDay: $currentDate)
                            .onChange(of: currentDate) { oldValue, newValue in
                                expenses = expensesService.getExpenses(for: currentDate)
                                if showMonth{
                                    dragOffsetAmount = 0
                                    showMonth = false
                                }
                            }
                            .transition(.opacity)
                    } else {
                        WeekDateView(weekOffset: 0, selectedDay: $currentDate)
                            .frame(height: 100)
                            .onChange(of: currentDate) { oldValue, newValue in
                                expenses = expensesService.getExpenses(for: currentDate)
                            }
                            .transition(.opacity) // La vista entra/desaparece deslizándose
                    }
                }
                .animation(.easeInOut, value: showMonth) // Anima el cambio de showMonth
            }
            .background(Color(.systemGray6))
            
            
            ZStack(alignment: .bottomTrailing) {
                VStack{
                    // Superponemos el área de arrastre con ZStack
                    ZStack {
                        // Área invisible para arrastre, superpuesta
                        Color.clear
                            .frame(height: 15) // Altura del área de arrastre
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .onAppear {
                                            // Combinamos el marco del Rectangle con esta área
                                            let clearFrame = geo.frame(in: .named("zstack"))
                                            self.rectangleFrame = clearFrame
                                        }
                                }
                            )
                        Rectangle()
                            .frame(width: 100, height: 2.5)
                            .padding(.top, 10)
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .onAppear {
                                            // Marco del Rectangle
                                            let rectFrame = geo.frame(in: .named("zstack"))
                                            self.rectangleFrame = rectFrame
                                        }
                                }
                            )
                           
                    }
                    .popoverTip(buttonTip)
                    if expenses.isEmpty {
                        ContentUnavailableView("Gastos", systemImage: "plus.circle", description: Text("Añade tus gastos para llevar tu control de lo que gastas."))
                            .onTapGesture {
                                isSheetPresented.toggle()
                            }
                    } else {
                        ScrollView {
                            GeometryReader { geometry in
                                Color.clear.preference(key: ScrollOffsetPreferenceKey.self,
                                                       value: geometry.frame(in: .named("scroll")).minY)
                            }
                            .frame(height: 0)
                            
                        
                            ForEach(expenses) { expense in
                                ExpenseDetailComponent(expense: expense)
                                    .contextMenu {
                                        Button {
                                            editExpense = expense
                                            isSheetPresented.toggle()
                                        } label: {
                                            Label("Editar", systemImage: "pencil")
                                        }
                                        Button {
                                            expensesService.deleteExpense(expense)
                                            triggerHapticFeedback()
                                            expenses = expensesService.getExpenses(for: currentDate)
                                        } label: {
                                            Label("Eliminar", systemImage: "delete.left")
                                        }
                                    }
                            }
                        }
                        .coordinateSpace(name: "scroll")
                        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                            contentOffset = value
                        }
                    }

                }
                Button {
                    editExpense = nil
                    isSheetPresented.toggle()
                } label: {
                    Image(systemName: "plus")
                        .font(.title.weight(.semibold))
                        .padding()
                        .background(Color.mainColor)
                        .foregroundColor(.white)
                        .clipShape(.circle)
                        .shadow(color: Color.mainColor.opacity(0.6), radius: 10, x: 0, y: 0)
                }
                .padding(.trailing)
            }


            .background(Color(.systemBackground))
            .clipShape(UnevenRoundedRectangle(
                topLeadingRadius: 15,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 15 )
            )
            .background(Color(.systemGray6))
            .offset(y: dragOffsetAmount + dragTranslation) // Combinamos offset final y arrastre en tiempo real
            .animation(.interactiveSpring(), value: dragOffsetAmount)
            .onTapGesture {
                if showMonth{
                    dragOffsetAmount = 0
                    showMonth = false
                }
            }
            .gesture(
                DragGesture()
                    .updating($dragTranslation) { value, state, _ in
                        // Solo actualizamos si el arrastre comienza en el Rectangle

                        if rectangleFrame.contains(value.startLocation) && value.translation.height > 0 {
                            state = value.translation.height
                        }
                        if(dragTranslation > 200 && !showMonth){
                            state = 0
                            showMonth = true
                            triggerHapticFeedback()
                        }
                            
                    }
                    .onEnded { value in
                        // Finalizamos el offset solo si comenzó en el Rectangle
                        if rectangleFrame.contains(value.startLocation) {
                            if value.translation.height > 500 {
                                dragOffsetAmount = 500
                                triggerHapticFeedback()
                            } else {
                                dragOffsetAmount = 0
                            }
                        }
                    }
            )
            .coordinateSpace(name: "zstack") // Espacio de coordenadas nombrado para el ZStack
            
            
            Spacer()
            HStack{
                Text("Total:")
                Text(getTotal(), format:.currency(code: Locale.current.currency?.identifier ?? "EUR"))
                    .frame(alignment: .bottom)
            }

        }//:: - Vstac
        .background(Color(.systemGray6))
        //.frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            expenses = expensesService.getExpenses(for: currentDate)
        }
        .sheet(isPresented: $isSheetPresented){
            ExpenseCreateSheetView(editExpense: $editExpense, isPresented: $isSheetPresented)
                .onDisappear{
                    expenses = expensesService.getExpenses(for: currentDate)
                }
        }
        
    }
    
    private func getTotal() -> Double{
        return expenses.reduce(0.0) { $0 + $1.amount }
    }
    private func triggerHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)  // Puede ser .success, .warning o .error
    }
    
}



#Preview("Data") {
    
    let testContainer = PreviewMockData.shared.testContainer
    
    let testContext = testContainer.mainContext

    let monsterCategory = PreviewMockData.shared.monsterCategory
    
    let dogFoodCategory = PreviewMockData.shared.dogFoodCategory
    
    testContainer.mainContext.insert(monsterCategory)
    
    testContainer.mainContext.insert(dogFoodCategory)
    
   
    let arrayExpenses = PreviewMockData.shared.sampleExpenses

    for expense in arrayExpenses{
        testContext.insert(expense)
    }
      
    return DailyExpenseView()
        .modelContainer(testContainer)

}
#Preview("No Data") {
    
    DailyExpenseView()

}

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
