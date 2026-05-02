//
//  GardenRowView.swift for a single spending category
//  BudgetBloom
//
//  Created by emily zhang on 11/5/2026.
//

import SwiftUI

struct GardenRowView: View {
    
    let title: String
    let growth: Double
    let budget: Double
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            
            HStack {
                Text(title)
                    .font(.subheadline)
                
                Spacer()
                
                Text(growth < 0.3 ? "🌱" :
                     growth < 0.7 ? "🌿" : "🌳")
            }
            
            if budget == 0 {
                Text("Set a budget")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            if budget > 0 {
                Text("\(Int(growth * 100))%")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    
                    Rectangle()
                        .frame(height: 8)
                        .foregroundColor(Color.gray.opacity(0.2))
                        .cornerRadius(4)
                    
                    Rectangle()
                        .frame(
                            width: max(0, geometry.size.width * growth),
                            height: 8
                        )
                        .foregroundColor(.green)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
    }
}

#Preview {
    GardenRowView(
        title: "Living",
        growth: 0.6,
        budget: 500
    )
}
