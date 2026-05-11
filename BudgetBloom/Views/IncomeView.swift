//
//  IncomeView.swift
//  BudgetBloom
//
//  Created by emily zhang on 11/5/2026.
//

import SwiftUI

enum IncomeFrequency: String, CaseIterable, Identifiable {
    case weekly = "Weekly"
    case fortnightly = "Fortnightly"
    case monthly = "Monthly"
    
    var id: String {
        rawValue
    }
    
    var monthlyMultiplier: Double {
        switch self {
        case .weekly:
            return 4.33
        case .fortnightly:
            return 2.165
        case .monthly:
            return 1
        }
    }
}

struct IncomeView: View {
    
    @ObservedObject var viewModel: ExpenseViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var incomeText: String = ""
    @State private var selectedFrequency: IncomeFrequency = .monthly
    
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                Text("Input your Income 🪙💵")
                    .font(.largeTitle)
                    .bold()
                
                Text("Enter your income and choose the frequency of your pay.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                currentIncomeSection
                
                incomeInputSection
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Income")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            incomeText = String(format: "%.2f", viewModel.income)
        }
        .alert("Invalid Input", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private var currentIncomeSection: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            Text("Current Monthly Income")
                .font(.headline)
            
            Text("$\(viewModel.income, specifier: "%.2f")")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.green)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private var incomeInputSection: some View {
        
    VStack(alignment: .leading, spacing: 14) {
        Text("Income Details")
                .font(.headline)
            TextField("Enter income", text: $incomeText)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
            
        HStack {
            Text("Frequency")
                Spacer()
                Picker("Frequency", selection: $selectedFrequency) {
                    ForEach(IncomeFrequency.allCases) { frequency in
                        Text(frequency.rawValue)
                            .tag(frequency)
                    }
                }
                .pickerStyle(.menu)
            }
            
            Button {
                saveIncome()
            } label: {
                Text("Save Income")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                incomeText = ""
            } label: {
                Text("Clear")
                    .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    func saveIncome() {
        
        guard !incomeText.isEmpty else {
            errorMessage = "Please enter an income value"
            showErrorAlert = true
            return
        }
        
        guard let value = Double(incomeText) else {
            errorMessage = "Please enter your income amount"
            showErrorAlert = true
            return
        }
        
        guard value > 0 else {
            errorMessage = "Income must be greater than 0"
            showErrorAlert = true
            return
        }
        
        let monthlyIncome = value * selectedFrequency.monthlyMultiplier
        
        viewModel.income = monthlyIncome
        viewModel.saveIncome()
        
        dismiss()
    }
}

#Preview {
    let vm = ExpenseViewModel()
    
    NavigationView {
        IncomeView(viewModel: vm)
    }
}
