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
