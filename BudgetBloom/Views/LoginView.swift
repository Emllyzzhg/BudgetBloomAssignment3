//
//  LoginView.swift
//  BudgetBloom
//
//  Created by Clayton Cheung on 5/5/2026.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var dbViewModel: ExpenseViewModel = ExpenseViewModel()
    @State private var name: String = ""
    @State private var password: String = ""
    
    @State private var isVisible: Bool = false
    @AppStorage("savedPassword") private var savedPassword: String = ""
    @State private var enterDash: Bool = false
    @State private var incorrectPass: Bool = false
    
    var body: some View {
        if savedPassword.isEmpty {
            VStack(spacing: 10) {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                    .padding()

                Text("Create a Password")
                    .font(.title2)
                    .padding()
                
                HStack {
                    if isVisible {
                        TextField("Password", text: $password)
                    }
                    else {
                        SecureField("Password", text: $password)
                    }
                    
                    Button(action: { isVisible.toggle() }) {
                        Image(systemName: isVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }

                Button("Save Password") {
                    savedPassword = password
                    password = ""
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            }
            .padding()
        }
        else {
            VStack(alignment: .center, spacing: 10) {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                    .padding()
                
                Text("Budget Bloom")
                    .font(.title2)
                    .padding()
                
                Text("Enter Password: ")
                HStack {
                    if isVisible {
                        TextField("Password", text: $password)
                    }
                    else {
                        SecureField("Password", text: $password)
                    }
                    
                    Button(action: { isVisible.toggle() }) {
                        Image(systemName: isVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                
                Button("Login") {
                    if password == savedPassword {
                        enterDash = true
                    }
                    else {
                        incorrectPass = true
                    }
                }
                .padding()
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .alert("Incorrect Password", isPresented: $incorrectPass) {
                    Button("Retry", role: .cancel) {}
                }
                message: {
                    Text("The password you entered is incorrect. Please try again.")
                }
                
                Button("Clear Password") { //only for testing purposes
                    savedPassword = ""
                    UserDefaults.standard.set(savedPassword, forKey: "password")
                    password = ""
                }
            }
            .padding()
            .navigationDestination(isPresented: $enterDash) {
                DashboardView(viewModel: dbViewModel)
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
}
