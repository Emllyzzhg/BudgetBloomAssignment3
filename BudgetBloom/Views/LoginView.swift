//
//  LoginView.swift
//  BudgetBloom
//
//  Created by Clayton Cheung on 5/5/2026.
//

import SwiftUI

struct LoginView: View {
    
    @State private var name: String = ""
    @State private var password: String = ""
    
    @State private var isVisible: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Enter Login Details: ")
            TextField("Username", text: $name)
            
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
            
//            NavigationLink("Login") {
//                DashboardView(viewModel: )
//            }
//            .padding(10)
//            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
