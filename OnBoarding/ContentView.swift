//
//  ContentView.swift
//  OnBoarding
//
//  Created by Vlad on 17/8/25.
//

import SwiftUI

struct ContentView: View {
    /// Agreement flag that drives whether onboarding is shown.
    /// NOTE: consider persisting with @AppStorage("hasAgreedToTerms") in production.
    @State private var hasAgreed: Bool = false
    // @AppStorage("hasAgreedToTerms") private var hasAgreed: Bool = false

    /// Controls initial presentation of the onboarding flow (sheet/stack/etc.).
    /// When `hasAgreed` becomes true, this view switches to the main app UI.
    @State private var showOnboarding: Bool = true

    var body: some View {
        if hasAgreed {
            // Main app entry once the user has agreed to terms.
            NavigationStack {
                Text("Welcome to Onboarding Demo App")
                    .font(.title3)
            }
        } else {
            // Onboarding flow:
            //  - `slides` define the 3-step narrative (benefits over features).
            //  - `icon` is the top hero; keep it simple to avoid jank on older devices.
            //  - `footer` shows contextual copy; on last slide it pairs with the Continue button.
            //  - `hasAgreed` and `showOnboarding` are bindings the onboarding updates.
            OnboardingView(
                tint: .orange, // Accent color for icons/buttons in onboarding
                slides: [
                    OnboardingSlide(
                        title: "Get Started",
                        cards: [
                            OnboardingCard(
                                symbol: "list.bullet.rectangle.fill",
                                title: "Track Your Progress",
                                subtitle: "Each tap moves you closer to the top of the leaderboard"
                            ),
                            OnboardingCard(
                                symbol: "person.crop.circle.badge.checkmark",
                                title: "Secure Profile",
                                subtitle: "Sign in securely with Apple and keep your identity private"
                            ),
                            OnboardingCard(
                                symbol: "person.2.fill",
                                title: "Connect & Compete",
                                subtitle: "Join a community of players and compete globally"
                            )
                        ]
                    ),
                    OnboardingSlide(
                        title: "Join the Competition",
                        cards: [
                            // TIP: consider `chart.line.uptrend.xyaxis` for growth/position visuals
                            OnboardingCard(
                                symbol: "lasso",
                                title: "Climb the Ranks",
                                subtitle: "Challenge others and aim for the #1 position every season"
                            ),
                            OnboardingCard(
                                symbol: "person.2.fill",
                                title: "Connect & Compete",
                                subtitle: "Join a community of players and compete globally"
                            ),
                            OnboardingCard(
                                symbol: "star.fill",
                                title: "Achieve Greatness",
                                subtitle: "Show the world your skills and dominate the leaderboard"
                            )
                        ]
                    ),
                    OnboardingSlide(
                        title: "Be the Best",
                        cards: [
                            OnboardingCard(
                                symbol: "star.fill",
                                title: "Achieve Greatness",
                                subtitle: "Show the world your skills and dominate the leaderboard"
                            ),
                            // NOTE: avoid implying monetary rewards if the app does not provide them.
                            OnboardingCard(
                                symbol: "trophy.fill",
                                title: "Earn Rewards",
                                subtitle: "Unlock achievements as you climb higher"
                            )
                        ]
                    )
                ],
                icon: {
                    // Hero icon at the top of each slide
                    Image(systemName: "swiftdata")
                        .font(.system(size: 80))
                        .frame(width: 120, height: 120)
                        .foregroundStyle(.primary)
                        .background(.orange.gradient, in: .rect(cornerRadius: 30))
                },
                footer: { tint in
                    // Footer copy shown across slides (last slide pairs it with a Continue button)
                    VStack(alignment: .leading, spacing: 8) {
                        Image(systemName: "person.3.fill")
                            .foregroundStyle(tint)
                        Text("Join the Race")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                        Text("Compete with others, climb the ranks, and see your name on top")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                },
                hasAgreed: $hasAgreed,         // set to true from the Agreement sheet
                showOnboarding: $showOnboarding // controls presentation of the onboarding container
            )
            // Consider `.transition(.opacity)` if this view wraps onboarding modally.
        }
    }
}

#Preview {
    ContentView()
}
