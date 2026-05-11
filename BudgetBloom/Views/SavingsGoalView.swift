//
//  SavingsGoalView.swift
//  BudgetBloom
//
//  Created by emily zhang on 11/5/2026.
//

import SwiftUI

enum GoalFruit: String, CaseIterable, Identifiable {
    case apple = "Apple 🍎"
    case orange = "Orange 🍊"
    case banana = "Banana 🍌"
    case strawberry = "Strawberry 🍓"
    case watermelon = "Watermelon 🍉"

var id: String {
        rawValue
    }
}

struct SavingsGoalsView: View {
    
    @ObservedObject var viewModel: ExpenseViewModel
    @State private var title = ""
    @State private var target = ""
    @State private var allocationAmounts: [UUID: String] = [:]
    @State private var selectedFruit: GoalFruit = .apple
    @State private var goalFruitAllocations: [UUID: GoalFruit] = [:]
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                Text("Savings Goals 🎯")
                    .font(.largeTitle)
                    .bold()
                
                Text("Add a saving goal and choose a fruit ")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                addGoalSection
                goalsSection
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Savings Goals")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadFruitAllocations()
        }
        .alert("Invalid Input", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private var addGoalSection: some View {
        
        VStack(alignment: .leading, spacing: 14) {
            
            Text("Add New Goal")
                .font(.headline)
            
            TextField("Name of Goal", text: $title)
                .textFieldStyle(.roundedBorder)
            
            TextField("Saving Goal", text: $target)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
            
            HStack {
                Text("Fruit Allocation : ")
                
                Spacer()
                
                Picker("Fruit Allocation", selection: $selectedFruit) {
                    ForEach(GoalFruit.allCases) { fruit in
                        Text(fruit.rawValue)
                            .tag(fruit)
                    }
                }
                .pickerStyle(.menu)
            }
            
            Button {
                addSavingGoal()
            } label: {
                Text("Add Saving Goal")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private var goalsSection: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Your Goals")
                .font(.headline)
            
            if viewModel.goals.isEmpty {
                
                VStack(spacing: 8) {
                    Text("No goals yet")
                        .font(.headline)
                    
                    Text("Add your first saving goal above.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                
            } else {
                
                ForEach(viewModel.goals) { goal in
                    goalCard(goal)
                }
            }
        }
    }
    
    private func goalCard(_ goal: SavingsGoal) -> some View {
        
    VStack(alignment: .leading, spacing: 10) {
            
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(goal.title)
                    .font(.headline)
                    
                Text("$\(goal.savedAmount, specifier: "%.2f") / $\(goal.targetAmount, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                }
                
        Spacer()
                
        Text(fruitForGoal(goal).rawValue)
                .font(.subheadline)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            
            ProgressView(value: goal.savedAmount, total: goal.targetAmount)
            
            TextField("Amount to allocate", text: Binding(
                get: {
                    allocationAmounts[goal.id] ?? ""
                },
                set: { newValue in
                    allocationAmounts[goal.id] = newValue
                }
            ))
            .keyboardType(.decimalPad)
            .textFieldStyle(.roundedBorder)
            
            Button {
                allocateMoney(to: goal)
            } label: {
                Text("Allocate Money")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .padding(8)
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    func allocateMoney(to goal: SavingsGoal) {
        
        guard let amountText = allocationAmounts[goal.id], !amountText.isEmpty else {
            errorMessage = "Please enter an amount to allocate"
            showErrorAlert = true
            return
        }
        
        guard let amount = Double(amountText) else {
            errorMessage = "Please enter a valid amount"
            showErrorAlert = true
            return
        }
        
        guard amount > 0 else {
            errorMessage = "Amount must be greater than 0"
            showErrorAlert = true
            return
        }
        
        guard amount <= viewModel.income else {
            errorMessage = "You cannot allocate more than your current monthly income"
            showErrorAlert = true
            return
        }
        
        guard let index = viewModel.goals.firstIndex(where: { $0.id == goal.id }) else {
            return
        }
        
        let remainingAmount = viewModel.goals[index].targetAmount - viewModel.goals[index].savedAmount
        
        guard amount <= remainingAmount else {
            errorMessage = "This amount is more than the remaining goal amount"
            showErrorAlert = true
            return
        }
        
        var updatedGoals = viewModel.goals
        updatedGoals[index].savedAmount += amount
        viewModel.goals = updatedGoals
        
        viewModel.income -= amount
        viewModel.saveIncome()
        
        allocationAmounts[goal.id] = ""
    }
    
    
    
    
    
    func addSavingGoal() {
        guard !title.isEmpty else {
            errorMessage = "Please enter a goal name"
            showErrorAlert = true
            return
        }
        guard let value = Double(target) else {
            errorMessage = "Please enter a valid saving goal amount"
            showErrorAlert = true
            return
        }
        
        guard value > 0 else {
            errorMessage = "Saving goal must be greater than 0"
            showErrorAlert = true
            return
        }
        
        let newGoal = SavingsGoal(
            title: title,
            targetAmount: value,
            savedAmount: 0
        )
        
        goalFruitAllocations[newGoal.id] = selectedFruit
        saveFruitAllocations()
        
        viewModel.addGoal(newGoal)
        
        title = ""
        target = ""
        selectedFruit = .apple
    }
    
    func fruitForGoal(_ goal: SavingsGoal) -> GoalFruit {
        return goalFruitAllocations[goal.id] ?? .apple
    }
    
    func saveFruitAllocations() {
        
        var savedDictionary: [String: String] = [:]
        
        for item in goalFruitAllocations {
            savedDictionary[item.key.uuidString] = item.value.rawValue
        }
        
        UserDefaults.standard.set(savedDictionary, forKey: "goalFruitAllocations")
    }
    
    func loadFruitAllocations() {
        
        guard let savedDictionary = UserDefaults.standard.dictionary(forKey: "goalFruitAllocations") as? [String: String] else {
            return
        }
        
        var loadedDictionary: [UUID: GoalFruit] = [:]
        
        for item in savedDictionary {
            if let uuid = UUID(uuidString: item.key),
               let fruit = GoalFruit(rawValue: item.value) {
                loadedDictionary[uuid] = fruit
            }
        }
        
        goalFruitAllocations = loadedDictionary
    }
}


