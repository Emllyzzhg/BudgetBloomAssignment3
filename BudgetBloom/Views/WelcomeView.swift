//
//  WelcomeView.swift
//  BudgetBloom
//
//  Created by Clayton Cheung on 5/5/2026.
//

import SwiftUI

struct WelcomeView: View {
    
    var body: some View {
        VStack (alignment: .center) {
            
            Image(systemName: "leaf.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
                .padding()
            
            Text("Welcome to Budget Bloom")
            NavigationLink("Start") {
                LoginView()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    WelcomeView()
}
