//
//  Budget.swift to track limits per category 
//  BudgetBloom
//
//  Created by emily zhang on 11/5/2026.
//

import Foundation

struct CategoryBudget: Identifiable, Codable {
    var id: UUID = UUID()
    var category: CategoryType
    var budget: Double
    var spent: Double
}
