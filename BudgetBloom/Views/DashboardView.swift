//
//  DashboardView.swift for main screen
//  BudgetBloom
//
//  Created by emily zhang on 11/5/2026.
//

import SwiftUI

struct DashboardView: View {
    
    @ObservedObject var viewModel: ExpenseViewModel
    @State private var showAddExpense = false
    @State private var goalFruitAllocations: [UUID: GoalFruit] = [:]
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                
                VStack(spacing: 18) {
                    
                    // Title
                    Text("BudgetBloom")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 30)
                    
                    ZStack { //Tree with fruits
                        Image(systemName: "tree.fill")
                            .font(.system(size: 275))
                            .symbolRenderingMode(.multicolor)
                        
                        ForEach(Array(viewModel.goals.enumerated()), id: \.element.id) { index, goal in
                            let progress = min(goal.savedAmount / goal.targetAmount, 1.0)
                            
                            FruitView(fruit: fruitForGoal(goal), progress: progress)
                                .offset(fruitPosition(for: index))
                        }
                    }
                    .frame(height: 320)
                    
                    // Income Section
                    NavigationLink(destination: IncomeView(viewModel: viewModel)) {
                        VStack(spacing: 8) {
                            Text("Monthly Income ☀️")
                                .font(.headline)
                            
                            Text("$\(viewModel.income, specifier: "%.2f")")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.yellow)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(16)
                    }
                    .buttonStyle(.plain)
                    
                    // Balance
                    VStack(spacing: 8) {
                        
                        Text("Balance")
                            .font(.headline)
                        
                        Text("$\(viewModel.balance, specifier: "%.2f")")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(viewModel.balance >= 0 ? .green : .red)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(16)
                    
                    // Garden Section
                    VStack(alignment: .leading, spacing: 14) {
                        
                        Text("My Garden 🌿")
                            .font(.headline)
                        
                        GardenRowView(title: "Living", growth: viewModel.growth(for: .living), budget: viewModel.budgets[.living] ?? 0)
                        GardenRowView(title: "Debt", growth: viewModel.growth(for: .debt), budget: viewModel.budgets[.debt] ?? 0)
                        GardenRowView(title: "Savings", growth: viewModel.growth(for: .savings), budget: viewModel.budgets[.savings] ?? 0)
                        GardenRowView(title: "Lifestyle", growth: viewModel.growth(for: .lifestyle), budget: viewModel.budgets[.lifestyle] ?? 0)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(16)
                    
                    // Expense List
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text("Recent Expenses")
                            .font(.headline)
                        
                        if viewModel.expenses.isEmpty {
                            Text("No expenses yet")
                                .foregroundColor(.gray)
                                .padding(.vertical, 8)
                        } else {
                            
                            ForEach(viewModel.expenses) { expense in
                                
                                HStack(spacing: 12) {
                                    
                                    Text(expense.category.gardenSymbol)
                                        .font(.title3)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(expense.title)
                                            .font(.subheadline)
                                            .bold()
                                        
                                        Text(expense.category.rawValue)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("$\(expense.amount, specifier: "%.2f")")
                                        .font(.subheadline)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(16)
                    
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
                            .cornerRadius(12)
                    }
                    
                    // View All Expense Button
                NavigationLink(destination: ExpenseListView(viewModel: viewModel)) {
                        Text("View All Expenses")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                    
                    // Savings Goals Button
                NavigationLink(destination: SavingsGoalsView(viewModel: viewModel)) {
                        Text("Savings Goals 🎯")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                    
                    // Settings Button
                NavigationLink(destination: SettingsView()) {
                        Text("Settings")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddExpense) {
                AddExpenseView(viewModel: viewModel)
            }
        }
    }
    
    func fruitPosition(for index: Int) -> CGSize {
        let positions: [CGSize] = [
            CGSize(width: -70, height: -80),
            CGSize(width: 60, height: -100),
            CGSize(width: -40, height: -20),
            CGSize(width: 80, height: -10),
            CGSize(width: 0, height: -130),
            CGSize(width: -90, height: 20),
            CGSize(width: 100, height: 40)
        ]
        
        return positions[index % positions.count]
    }
    
    func fruitForGoal(_ goal: SavingsGoal) -> GoalFruit {
        guard let savedDictionary = UserDefaults.standard.value(forKey: "goalFruitAllocations") as? [String: String]
        else {
            return .apple
        }
        
        guard let fruitRawValue = savedDictionary[goal.id.uuidString],
              let fruit = GoalFruit(rawValue: fruitRawValue)
        else {
            return .apple
        }
        
        return fruit
    }
}

#Preview {
    DashboardView(viewModel: ExpenseViewModel())
}
