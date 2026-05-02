//
//  SavingsGoal.swift
//  BudgetBloom
//
//  Created by emily zhang on 11/5/2026.
//

import Foundation

struct SavingsGoal: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var targetAmount: Double
    var savedAmount: Double
}
