//
//  ContentView.swift
//  OnBoarding
//
//  Created by Vlad on 17/8/25.
//

import SwiftUI

struct ContentView: View {
    @State private var hasAgreed: Bool = false
    // @AppStorage("hasAgreedToTerms") private var hasAgreed: Bool = false
    @State private var showOnboarding: Bool = true
    
    var body: some View {
        if hasAgreed {
            NavigationStack {
                Text("Welcome to Onboarding Demo App")
                    .font(.title3)
            }
        } else {
            AppleOnboardingView(
                tint: .orange,
                slides: [
                    OnboardingSlide(
                        title: "Get Started",
                        cards: [
                            AppleOnboardingCard(
                                symbol: "list.bullet.rectangle.fill",
                                title: "Track Your Progress",
                                subtitle: "Each tap moves you closer to the top of the leaderboard"
                            ),
                            AppleOnboardingCard(
                                symbol: "person.crop.circle.badge.checkmark",
                                title: "Secure Profile",
                                subtitle: "Sign in securely with Apple and keep your identity private"
                            ),
                            AppleOnboardingCard(
                                symbol: "person.2.fill",
                                title: "Connect & Compete",
                                subtitle: "Join a community of players and compete globally"
                            )
                        ]
                    ),
                    OnboardingSlide(
                        title: "Join the Competition",
                        cards: [
                            AppleOnboardingCard(
                                symbol: "lasso",
                                title: "Climb the Ranks",
                                subtitle: "Challenge others and aim for the #1 position every season"
                            ),
                            AppleOnboardingCard(
                                symbol: "person.2.fill",
                                title: "Connect & Compete",
                                subtitle: "Join a community of players and compete globally"
                            ),
                            AppleOnboardingCard(
                                symbol: "star.fill",
                                title: "Achieve Greatness",
                                subtitle: "Show the world your skills and dominate the leaderboard"
                            )
                        ]
                    ),
                    OnboardingSlide(
                        title: "Be the Best",
                        cards: [
                            AppleOnboardingCard(
                                symbol: "star.fill",
                                title: "Achieve Greatness",
                                subtitle: "Show the world your skills and dominate the leaderboard"
                            ),
                            AppleOnboardingCard(
                                symbol: "trophy.fill",
                                title: "Earn Rewards",
                                subtitle: "Unlock achievements as you climb higher"
                            )
                        ]
                    )
                ],
                icon: {
                    Image(systemName: "swiftdata")
                        .font(.system(size: 80))
                        .frame(width: 120, height: 120)
                        .foregroundStyle(.primary)
                        .background(.orange.gradient, in: .rect(cornerRadius: 30))
                },
                footer: { tint in
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
                hasAgreed: $hasAgreed,
                showOnboarding: $showOnboarding
            )
        }
    }
}

#Preview {
    ContentView()
}
