//
//  ContentView.swift
//  OnBoarding
//
//  Created by Vlad on 17/8/25.
//
import SwiftUI

struct ContentView: View {
    @State private var hasAgreed: Bool = false
//    @AppStorage("hasAgreedToTerms") private var hasAgreed: Bool = false
    @State private var showOnboarding: Bool = true
    
    var body: some View {
        NavigationStack {
            List {}
            .navigationTitle("OnBoarding")
        }
        .sheet(isPresented: $showOnboarding) {
            AppleOnboardingView(
                tint: .blue,
                title: "Welcome to Onboarding Demo App",
                icon: {
                    Image(systemName: "swiftdata")
                        .font(.system(size: 60))
                        .frame(width: 120, height: 120)
                        .foregroundStyle(.white)
                        .background(.blue.gradient, in: .rect(cornerRadius: 30))
                        .frame(height: 200)
                },
                cards: {
                    AppleOnboardingCard(
                        symbol: "list.bullet.rectangle.fill",
                        title: "Track Your Progress",
                        subtitle: "Each tap moves you closer to the top of the leaderboard"
                    )
                    AppleOnboardingCard(
                        symbol: "person.crop.circle.badge.checkmark",
                        title: "Secure Profile",
                        subtitle: "Sign in securely with Apple and keep your identity private"
                    )
                    AppleOnboardingCard(
                        symbol: "lasso",
                        title: "Climb the Ranks",
                        subtitle: "Challenge others and aim for the #1 position every season"
                    )
                },
                footer: {
                    VStack(alignment: .leading, spacing: 8) {
                        Image(systemName: "person.3.fill")
                            .foregroundStyle(.blue)
                        Text("Join the Race")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                        Text("Compete with others, climb the ranks, and see your name on top")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 20)
                },
                showOnboarding: $showOnboarding
            )
        }
        .onAppear {
            showOnboarding = !hasAgreed
        }
    }
}

#Preview {
    ContentView()
}
