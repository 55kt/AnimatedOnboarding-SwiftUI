//
//  AppleOnboardingView.swift
//  OnBoarding
//
//  Created by Vlad on 17/8/25.
//

import SwiftUI

/// Onboarding Card
struct AppleOnboardingCard: Identifiable {
    var id: String = UUID().uuidString
    var symbol: String
    var title: String
    var subtitle: String
}

@resultBuilder
struct OnboardingCardResultBuilder {
    static func buildBlock(_ components: AppleOnboardingCard...) -> [AppleOnboardingCard] {
        components
    }
}

struct AppleOnboardingView<Icon: View, Footer: View>: View {
    var tint: Color
    var title: String
    var icon: Icon
    var cards: [AppleOnboardingCard]
    var footer: Footer
    @Binding var showOnboarding: Bool
    @State private var showAgreement: Bool = false
    
    init(tint: Color, title: String, @ViewBuilder icon: @escaping () -> Icon, @OnboardingCardResultBuilder cards: @escaping () -> [AppleOnboardingCard], @ViewBuilder footer: @escaping () -> Footer, showOnboarding: Binding<Bool>) {
        self.tint = tint
        self.title = title
        self.icon = icon()
        self.cards = cards()
        self.footer = footer()
        self._showOnboarding = showOnboarding
        self._animateIcon = .init(initialValue: Array(repeating: false, count: cards().count))
        self._animateTitle = .init(initialValue: Array(repeating: false, count: cards().count))
        self._animateCard = .init(initialValue: Array(repeating: false, count: cards().count))
    }
    
    // MARK: - Properties
    @State private var currentPage: Int = 0
    @State private var animateIcon: [Bool]
    @State private var animateTitle: [Bool]
    @State private var animateCard: [Bool]
    @State private var animateFooterAndButton: Bool = false
    
    var body: some View {
        TabView(selection: $currentPage) {
            ForEach(cards.indices, id: \.self) { index in
                VStack(spacing: 30) {
                    icon
                        .frame(maxWidth: .infinity)
                        .blurSlide(animateIcon[index])
                    
                    Text(title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .blurSlide(animateTitle[index])
                    
                    CardView(card: cards[index])
                        .blurSlide(animateCard[index])
                    
                    if index == cards.count - 1 {
                        VStack(spacing: 15) {
                            footer
                                .blurSlide(animateFooterAndButton)
                            
                            Button(action: { showAgreement = true }) {
                                Text("Continue")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                            }
                            .tint(tint)
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.capsule)
                            .padding(.horizontal, 30)
                            .blurSlide(animateFooterAndButton)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 50)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tag(index)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .interactiveDismissDisabled()
        .allowsHitTesting(currentPage == cards.count - 1 ? animateFooterAndButton : true)
        .onChange(of: currentPage) { _, newValue in
            Task {
                animateIcon[newValue] = false
                animateTitle[newValue] = false
                animateCard[newValue] = false
                animateFooterAndButton = false
                
                await delayedAnimation(0.2) {
                    animateIcon[newValue] = true
                }
                await delayedAnimation(0.4) {
                    animateTitle[newValue] = true
                }
                await delayedAnimation(0.6) {
                    animateCard[newValue] = true
                }
                if newValue == cards.count - 1 {
                    await delayedAnimation(0.8) {
                        animateFooterAndButton = true
                    }
                }
            }
        }
        .task {
            await delayedAnimation(0.2) {
                animateIcon[0] = true
            }
            await delayedAnimation(0.4) {
                animateTitle[0] = true
            }
            await delayedAnimation(0.6) {
                animateCard[0] = true
            }
        }
        .sheet(isPresented: $showAgreement) {
            AgreementSheetView(tint: tint) {
                showOnboarding = false
            }
        }
    }
    
    /// Card View
    @ViewBuilder
    func CardView(card: AppleOnboardingCard) -> some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: card.symbol)
                .font(.title)
                .foregroundStyle(.tint)
                .frame(width: 50)
                .offset(y: 10)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(card.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Text(card.subtitle)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
            }
        }
        .padding(.horizontal, 20)
    }
    
    func delayedAnimation(_ delay: Double, action: @escaping () -> ()) async {
        try? await Task.sleep(for: .seconds(delay))
        withAnimation(.smooth) {
            action()
        }
    }
}

extension View {
    /// Custom blur slide effect
    @ViewBuilder
    func blurSlide(_ show: Bool) -> some View {
        self
            .compositingGroup()
            .blur(radius: show ? 0 : 10)
            .opacity(show ? 1 : 0)
            .offset(y: show ? 0 : 100)
    }
}

#Preview {
    ContentView()
}
