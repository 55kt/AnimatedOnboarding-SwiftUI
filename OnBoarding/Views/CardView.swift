//
//  CardView.swift
//  OnBoarding
//
//  Created by Vlad on 17/8/25.
//

import SwiftUI

/// Single benefit row used inside onboarding slides.
/// - Uses SF Symbol on the left and a vertical text stack on the right.
/// - Keeps layout flexible (no hard heights) to play well with Dynamic Type.
struct CardView: View {
    let card: OnboardingCard
    let tint: Color

    var body: some View {
        HStack(alignment: .center, spacing: 15) {

            // Leading icon:
            // - Large but constrained so it doesn't push text off-screen.
            // - Hierarchical rendering keeps it visually consistent with tint.
            Image(systemName: card.symbol)
                .symbolRenderingMode(.hierarchical)
                .font(.system(size: 50))
                .foregroundStyle(tint)
                .frame(width: 50, height: 50, alignment: .center)
                .accessibilityHidden(true) // title already conveys meaning for VoiceOver

            // Copy block:
            // - Title is single-line with scale fallback.
            // - Subtitle supports up to 3 lines and uses secondary color.
            VStack(alignment: .leading, spacing: 5) {
                Text(card.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9) // avoid truncation on smaller widths

                Text(card.subtitle)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true) // prevent unexpected truncation
                    .lineLimit(3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        // Container padding keeps touch targets comfortable and spacing consistent
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)

        // Accessibility: group the row as a single element with a concise label
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(card.title). \(card.subtitle)")
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
