//
//  DashboardView.swift for main screen
//  BudgetBloom
//
//  Created by emily zhang on 11/5/2026.
//


// Input Income using Navigation Link

import SwiftUI

struct DashboardView: View {
    
    @ObservedObject var viewModel: ExpenseViewModel
    @State private var showAddExpense = false
    
    // User Interface
    var body: some View {
        NavigationView {
            
            ScrollView {
                
                VStack(spacing: 20) {
                    
                    // Title
                    Text("BudgetBloom")
                        .font(.largeTitle)
                        .bold()
                    
                    // Income Section
                    NavigationLink(destination: IncomeView(viewModel: viewModel)) {
                        VStack(spacing: 6) {
                            Text("Monthly Income ☀️")
                                .font(.headline)
                            
                            Text("$\(viewModel.income, specifier: "%.2f")")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.yellow)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    // Balance
                    VStack(spacing: 6) {
                        
                        Text("Balance")
                            .font(.headline)
                        
                        Text("$\(viewModel.balance, specifier: "%.2f")")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(viewModel.balance >= 0 ? .green : .red)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Garden Section
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text("My Garden 🌿")
                            .font(.headline)
                        
                        GardenRowView(title: "Living", growth: viewModel.growth(for: .living), budget: viewModel.budgets[.living] ?? 0)
                        GardenRowView(title: "Debt", growth: viewModel.growth(for: .debt), budget: viewModel.budgets[.debt] ?? 0)
                        GardenRowView(title: "Savings", growth: viewModel.growth(for: .savings), budget: viewModel.budgets[.savings] ?? 0)
                        GardenRowView(title: "Lifestyle", growth: viewModel.growth(for: .lifestyle), budget: viewModel.budgets[.lifestyle] ?? 0)
                    }
                    .padding()
                    
                    // Expense List
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text("Recent Expenses")
                            .font(.headline)
                        
                        if viewModel.expenses.isEmpty {
                            Text("No expenses yet")
                                .foregroundColor(.gray)
                        } else {
                            
                            ForEach(viewModel.expenses) { expense in
                                
                                HStack {
                                    Text(expense.category.gardenSymbol)
                                    VStack(alignment: .leading) {
                                        Text(expense.title)
                                            .font(.subheadline)
                                        
                                        Text(expense.category.rawValue)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("$\(expense.amount, specifier: "%.2f")")
                                }
                            }
                        }
                    }
                    
                    // Add Expense Button
                    Button {
                        showAddExpense = true
                    } label: {
                        Text("+ Add Expense")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    // View all expense button
                    NavigationLink(destination: ExpenseListView(viewModel: viewModel)) {
                        Text("View All Expenses")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                        
                    }
                    .padding()
                    
                    // Savings Goals Button
                    NavigationLink(destination: SavingsGoalsView(viewModel: viewModel)) {
                        Text("Savings Goals 🎯")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    NavigationLink(destination: SettingsView()) {
                        Text("Settings")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(10)
                        
                    }
                    .padding()
                }
                .sheet(isPresented: $showAddExpense) {
                    AddExpenseView(viewModel: viewModel)
                }
            }
        }
    }
}
    
#Preview {
    let vm = ExpenseViewModel()
    
    vm.income = 2500
    
    vm.expenses = [
        Expense(title: "Groceries", amount: 45.50, category: .living),
        Expense(title: "Coffee", amount: 8.00, category: .lifestyle),
        Expense(title: "Rent", amount: 2000.00, category: .living)
    ]
    
    return DashboardView(viewModel: vm)
}
