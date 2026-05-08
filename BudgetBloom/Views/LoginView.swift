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
    @State private var hasPass: Bool = true
    
    var body: some View {
        if !hasPass {
            
        }
        else {
            VStack(alignment: .center) {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                    .padding()
                
                Text("Budget Bloom")
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
                
                NavigationLink("Login") {
                    DashboardView(viewModel: dbViewModel)
                }
                .padding(10)
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}

#Preview {
    LoginView()
}
