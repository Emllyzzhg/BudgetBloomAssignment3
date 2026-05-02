//
//  SavingsGoalView.swift
//  BudgetBloom
//
//  Created by emily zhang on 11/5/2026.
//

import SwiftUI

struct SavingsGoalsView: View {
    
    @ObservedObject var viewModel: ExpenseViewModel
    @State private var title = ""
    @State private var target = ""
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 20) {
                
                Text("Savings Goals 🎯")
                    .font(.largeTitle)
                    .bold()
                
                // Input section
                VStack(spacing: 12) {
                    
                    TextField("Goal (e.g. Laptop)", text: $title)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Target Amount", text: $target)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("Add Goal") {
                        if let value = Double(target), !title.isEmpty {
                            
                            let goal = SavingsGoal(
                                title: title,
                                targetAmount: value,
                                savedAmount: 0
                            )
                            
                            viewModel.goals.append(goal)
                            
                            title = ""
                            target = ""
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                
                // List of goals
                List {
                    ForEach(viewModel.goals) { goal in
                        
                        VStack(alignment: .leading, spacing: 6) {
                            
                            Text(goal.title)
                                .font(.headline)
                            
                            Text("$\(goal.savedAmount, specifier: "%.2f") / \(goal.targetAmount, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            ProgressView(value: goal.savedAmount, total: goal.targetAmount)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    let vm: ExpenseViewModel = ExpenseViewModel()
    
    vm.goals = [
        SavingsGoal(title: "Laptop", targetAmount: 2000, savedAmount: 500),
        SavingsGoal(title: "Holiday", targetAmount: 3000, savedAmount: 1200),
        SavingsGoal(title: "Car", targetAmount: 10000, savedAmount: 2500)
    ]
    
    return SavingsGoalsView(viewModel: vm)
}
