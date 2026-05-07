//
//  ExpenseListView.swift
//  BudgetBloom
//
//  Created by emily zhang on 11/5/2026.
//

import SwiftUI

struct ExpenseListView: View {
    
    @ObservedObject var viewModel: ExpenseViewModel
    @State private var editMode: Bool = false
    
    @State private var selectedCategory: CategoryType? = nil
    
    // Filtered Expenses
    var filteredExpenses: [Expense] {
        if let selectedCategory {
            return viewModel.expenses.filter { $0.category == selectedCategory }
        } else {
            return viewModel.expenses
        }
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                // Filter Picker
                Picker("Filter", selection: $selectedCategory) {
                    
                    Text("All").tag(CategoryType?.none)
                    
                    ForEach(CategoryType.allCases, id: \.self) { category in
                        Text(category.rawValue)
                            .tag(CategoryType?.some(category))
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Budget
                Section(header: Text("Set Budget")) {
                    ForEach(CategoryType.allCases, id: \.self) { category in
                        HStack {
                            Text(category.rawValue)
                            Spacer()
                            TextField(
                                "0",
                                value: Binding(
                                    get: {
                                        viewModel.budgets[category] ?? 0
                                    },
                                    set: { newValue in
                                        viewModel.setBudget(for: category, amount: newValue)
                                    }
                                ),
                                formatter: NumberFormatter()
                            )
                            .keyboardType(.decimalPad)
                            .frame(width: 80)
                            .disabled(!editMode)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Expense List
                List {
                    if editMode {
                        ForEach(filteredExpenses) { expense in
                            HStack {
                                Text(expense.category.gardenSymbol)
                                    .font(.title3)
                                
                                VStack(alignment: .leading) {
                                    Text(expense.title)
                                        .font(.headline)
                                    
                                    Text(expense.category.rawValue)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                Text("$\(expense.amount, specifier: "%.2f")")
                            }
                        }
                        .onDelete(perform: deleteExpense)
                    }
                    else {
                        ForEach(filteredExpenses) { expense in
                            HStack {
                                Text(expense.category.gardenSymbol)
                                    .font(.title3)
                                
                                VStack(alignment: .leading) {
                                    Text(expense.title)
                                        .font(.headline)
                                    
                                    Text(expense.category.rawValue)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                Text("$\(expense.amount, specifier: "%.2f")")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Expenses")
            .toolbar {
                Button(editMode ? "Done" : "Edit") {
                    editMode.toggle()
                }
            }
        }
    }
    
    // Delete Function
    func deleteExpense(at offsets: IndexSet) {
        for index in offsets {
            let expense = filteredExpenses[index]
            viewModel.deleteExpense(expense)
            }
        }
}


#Preview {
    let vm = ExpenseViewModel()
    
    vm.income = 2500
    
    vm.expenses = [
        Expense(title: "Lunch", amount: 15.50, category: .living),
        Expense(title: "Bus", amount: 5.20, category: .lifestyle),
        Expense(title: "Rent", amount: 2000, category: .living)
    ]
    
    return ExpenseListView(viewModel: vm)
}
