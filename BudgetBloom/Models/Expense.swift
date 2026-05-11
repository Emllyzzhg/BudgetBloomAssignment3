//
//  Expense.swift for money user spends
//  BudgetBloom
//
//  Created by emily zhang on 11/5/2026.
//

import Foundation

struct Expense: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var amount: Double
    var category: CategoryType
    var date: Date = Date()
    var emoji: String
}
