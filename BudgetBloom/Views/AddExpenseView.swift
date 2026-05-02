//
//  AddExpenseView.swift for input screen for expenses (enter from DashboardView)
//  BudgetBloom
//
//  Created by emily zhang on 11/5/2026.
//

import SwiftUI

struct AddExpenseView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ExpenseViewModel
    
    @State private var title: String = ""
    @State private var amount: String = ""
    @State private var selectedCategory: CategoryType = CategoryType.living
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        
        NavigationView {
            
            Form {
                
                // Expense title
                Section(header: Text("Expense Details")) {
                    TextField("Title (e.g. Lunch)", text: $title)
                    
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                }
                
                // Category selection
                Section(header: Text("Category")) {
                    
                    Picker("Select Category", selection: $selectedCategory) {
                        ForEach(CategoryType.allCases, id: \.self) { category in
                            Text(category.rawValue)
                                .tag(category)
                        }
                    }
                }
            }
            .toolbar {
                
                // Cancel button
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                // Save button
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveEntry()
                    }
                }
            }
            .navigationTitle("Add Entry")
            
            .alert("Invalid Input", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    // Save Expense
    func saveEntry() {
        
        // Checks if title is entered
        guard !title.isEmpty else {
            errorMessage = "Please enter a title"
            showErrorAlert = true
            return
        }
        // Checks if input is a Double
        guard let amountValue = Double(amount) else {
            errorMessage = "Please enter a valid amount"
            showErrorAlert = true
            return
        }
        // Checks for valid positive input
        guard amountValue > 0 else {
            errorMessage = "Amount must be greater than 0"
            showErrorAlert = true
            return
        }
        // Save expense
        let newExpense = Expense(
            title: title,
            amount: amountValue,
            category: selectedCategory
        )
        
        viewModel.addExpense(newExpense)
        
        dismiss()
    }
}

#Preview {
    AddExpenseView(viewModel: ExpenseViewModel())
}
