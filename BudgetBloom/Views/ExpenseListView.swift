//
//  ExpenseListView.swift
//  BudgetBloom
//
//  Created by emily zhang on 11/5/2026.
//

import SwiftUI

struct ExpenseListView: View {
    
    @ObservedObject var viewModel: ExpenseViewModel
    
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
            
            VStack(spacing: 15) {
                
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
                .cornerRadius(15)
                .padding(.horizontal)
                
                // Budget
                Section(header:
                    Text("Set Budget")
                        .font(.headline)
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                ) {
                    VStack(spacing: 12) {
                        ForEach(CategoryType.allCases, id: \.self) { category in
                            HStack {
                                Text(category.rawValue)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
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
                                .padding(8)
                                .background(Color.white)
                                .cornerRadius(10)
                                .multilineTextAlignment(.center)
                            }
                            .padding()
                            .background(Color.green.opacity(0.10))
                            .cornerRadius(15)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Expense List
                List {
                    ForEach(filteredExpenses) { expense in
                        HStack(spacing: 12) {
                            
                            Text(expense.emoji)
                                .font(.title2)
                                .frame(width: 40, height: 40)
                                .cornerRadius(12)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(expense.title)
                                    .font(.headline)
                                
                                Text(expense.category.rawValue)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Text("$\(expense.amount, specifier: "%.2f")")
                                .font(.headline)
                        }
                        .padding(.vertical, 6)
                    }
                    .onDelete(perform: deleteExpense)
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Expenses")
            .navigationBarItems(
                leading: EditButton(),
                trailing: NavigationLink(destination: AddExpenseView(viewModel: viewModel)) {
                    Image(systemName: "plus")
                        .foregroundColor(.green)
                }
            )
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
    let vm: ExpenseViewModel = {
        let vm = ExpenseViewModel()
        
        vm.income = 2500
        
        vm.expenses = [
            Expense(title: "Lunch", amount: 15.50, category: .living, emoji: "🍕"),
            Expense(title: "Bus", amount: 5.20, category: .lifestyle, emoji: "🚙"),
            Expense(title: "Rent", amount: 2000, category: .living, emoji: "🛋️")
        ]
        
        return vm
    }()
    
    ExpenseListView(viewModel: vm)
}
