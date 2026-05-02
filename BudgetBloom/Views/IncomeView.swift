//
//  IncomeView.swift
//  BudgetBloom
//
//  Created by emily zhang on 11/5/2026.
//

import SwiftUI

struct IncomeView: View {
    
    @ObservedObject var viewModel: ExpenseViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var incomeText: String = ""
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        
        NavigationView {
            
            Form {
                
                Section(header: Text("Monthly Income")) {
                    TextField("Enter income", text: $incomeText)
                        .keyboardType(.decimalPad)
                }
                
                Section {
                    Button("Save") {
                        saveIncome()
                    }
                }
            }
            .navigationTitle("Income")
            .onAppear {
                incomeText = String(format: "%.2f", viewModel.income)
            }
            .alert("Invalid Input", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    func saveIncome() {
        // Checks for empty input
        guard !incomeText.isEmpty else {
            errorMessage = "Please enter an income value"
            showErrorAlert = true
            return
        }
        // Checks for a valid input
        guard let value = Double(incomeText), value > 0 else {
            errorMessage = "Please enter an income greater than 0"
            showErrorAlert = true
            return
        }
            
        viewModel.income = value
        viewModel.saveIncome()
            
        dismiss()
    }
}

#Preview {
    let vm = ExpenseViewModel()
    return IncomeView(viewModel: vm)
}
