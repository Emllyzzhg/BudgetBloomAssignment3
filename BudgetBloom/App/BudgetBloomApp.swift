//
//  BudgetBloomApp.swift
//  BudgetBloom
//
//  Created by emily zhang on 11/5/2026.
//

import SwiftUI

@main
struct BudgetBloomApp: App {
    
    @StateObject var viewModel = ExpenseViewModel()
    
    var body: some Scene {
        WindowGroup {
            DashboardView(viewModel: viewModel)
        }
    }
}
