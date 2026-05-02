//
//  CategoryTypeGarden.swift
//  BudgetBloom
//
//  Created by emily zhang on 11/5/2026.
//

import Foundation

extension CategoryType {
    
    var gardenSymbol: String {
        switch self {
        case .living:
            return "💧"
        case .debt:
            return "🌿"
        case .lifestyle:
            return "🌸"
        case .savings:
            return "🌳"
        }
    }
}
