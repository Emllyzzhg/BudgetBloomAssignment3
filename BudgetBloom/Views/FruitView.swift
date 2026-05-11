//
//  FruitView.swift
//  BudgetBloom
//
//  Created by Clayton Cheung on 11/5/2026.
//

import SwiftUI

struct FruitView: View {
    
    let fruit: GoalFruit
    let progress: Double
    
    var body: some View {
        Text(fruitEmoji)
            .font(Font.system(size: fruitSize))
            .animation(.spring(), value: progress)
    }
    
    var fruitSize: CGFloat {
        max(20, 20 + (progress * 50))
    }
    
    var fruitEmoji: String {
        switch fruit {
        case .apple:
            return "🍎"
        case .orange:
            return "🍊"
        case .banana:
            return "🍌"
        case .strawberry:
            return "🍓"
        case .watermelon:
            return "🍉"
        }
    }
}
