//
//  SettingsView.swift
//  BudgetBloom
//
//  Created by Clayton Cheung on 8/5/2026.
//

import SwiftUI

struct SettingsView: View {
    @State private var newPass: String = ""
    @State private var isVisible: Bool = false
    
    @AppStorage("savedPassword") private var savedPassword: String = ""
    @State private var success: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Change Password")
            
            HStack(alignment: .center) {
                Text("Password: ")
                
                if isVisible {
                    TextField("Password", text: $newPass)
                }
                else {
                    SecureField("Password", text: $newPass)
                }
                
                Button(action: { isVisible.toggle() }) {
                    Image(systemName: isVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            Button("Change Password") {
                savedPassword = newPass
                newPass = ""
                success = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .alert("Password Changeed", isPresented: $success) {
                Button("Ok", role: .cancel) {}
            }
            message: {
                Text("You have successfully changed your password")
            }
        }
        .padding()
        .navigationTitle("Settings")
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
