//
//  CategoryType.swift contains all categories. Income is not an expense so should not be on this list
//  BudgetBloom
//
//  Created by emily zhang on 11/5/2026.
//

import Foundation

enum CategoryType: String, CaseIterable, Codable {
    case living = "Living"
    case debt = "Debt"
    case lifestyle = "Lifestyle"
    case savings = "Savings"
}
