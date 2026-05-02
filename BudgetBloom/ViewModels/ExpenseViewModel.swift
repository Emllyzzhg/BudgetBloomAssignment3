//
//  ExpenseViewModel.swift for data management, saving and loading using UserDefaults and Codable
//  BudgetBloom
//
//  Created by emily zhang on 11/5/2026.
//

import Foundation
import Combine

class ExpenseViewModel: ObservableObject {
    
    @Published var expenses: [Expense] = []
    @Published var income: Double = 0
    @Published var goals: [SavingsGoal] = []
    
    @Published var budgets: [CategoryType: Double] = [
            .living: 0,
            .debt: 0,
            .savings: 0,
            .lifestyle: 0
        ]
    
    init() {
        loadExpenses()
        loadIncome()
        loadBudgets()
        loadGoals()
    }
    
    // Add Expense
    func addExpense(_ expense: Expense) {
        expenses.append(expense)
        saveExpenses()
    }
    
    // Save Expenses
    func saveExpenses() {
        if let encoded = try? JSONEncoder().encode(expenses) {
            UserDefaults.standard.set(encoded, forKey: "expenses")
        }
    }
    
    // Load Expenses
    func loadExpenses() {
        if let data = UserDefaults.standard.data(forKey: "expenses"),
           let decoded = try? JSONDecoder().decode([Expense].self, from: data) {
            expenses = decoded
        }
    }
    
    // Delete Expenses
    func deleteExpense(_ expense: Expense) {
        expenses.removeAll { $0.id == expense.id }
        saveExpenses()
    }
    
    // Save Income
    func saveIncome() {
        UserDefaults.standard.set(income, forKey: "income")
    }
    
    // Load Income
    func loadIncome() {
        income = UserDefaults.standard.double(forKey: "income")
    }
    
    // Save budget
    func saveBudgets() {
        if let encoded = try? JSONEncoder().encode(budgets) {
            UserDefaults.standard.set(encoded, forKey: "budgets")
        }
    }
    
    // Load budget
    func loadBudgets() {
        if let data = UserDefaults.standard.data(forKey: "budgets"),
           let decoded = try? JSONDecoder().decode([CategoryType: Double].self, from: data) {
            budgets = decoded
        }
    }
    
    // Set budget
    func setBudget(for category: CategoryType, amount: Double) {
        budgets[category] = amount
        saveBudgets()
    }
    
    // Total
    var totalSpent: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    //Category Total
    func total(for category: CategoryType) -> Double {
        expenses
            .filter { $0.category == category }
            .reduce(0) { $0 + $1.amount }
    }
    
    // Balance
    var balance: Double {
        income - totalSpent
    }
    
    // Garden Growth
    func growth(for category: CategoryType) -> Double {
        let spent = total(for: category)
        let budget = budgets[category] ?? 0
            
        guard budget > 0 else { return 0 }
        
        let value = spent / budget
        return value.isFinite ? min(value, 1.0) : 0
    }
    
    // Add Goals
    func addGoal(_ goal: SavingsGoal) {
        goals.append(goal)
        saveGoals()
    }
    
    // Save Goals
    func saveGoals() {
        if let encoded = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(encoded, forKey: "goals")
        }
    }
    
    // Load Goals
    func loadGoals() {
        if let data = UserDefaults.standard.data(forKey: "goals"),
           let decoded = try? JSONDecoder().decode([SavingsGoal].self, from: data) {
            goals = decoded
        }
    }
}
