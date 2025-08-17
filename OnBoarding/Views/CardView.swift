//
//  CardView.swift
//  OnBoarding
//
//  Created by Vlad on 17/8/25.
//

import SwiftUI

struct CardView: View {
    let card: OnboardingCard
    let tint: Color
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            Image(systemName: card.symbol)
                .font(.system(size: 50))
                .foregroundStyle(tint)
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(card.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Text(card.subtitle)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    CardView(
        card: OnboardingCard(
            symbol: "list.bullet.rectangle.fill",
            title: "Track Your Progress",
            subtitle: "Each tap moves you closer to the top of the leaderboard"
        ),
        tint: .orange
    )
}
