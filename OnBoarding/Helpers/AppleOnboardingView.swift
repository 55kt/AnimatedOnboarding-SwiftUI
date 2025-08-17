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

/// Onboarding Slide
struct OnboardingSlide {
    var title: String
    var cards: [AppleOnboardingCard]
}

@resultBuilder
struct OnboardingSlideResultBuilder {
    static func buildBlock(_ components: OnboardingSlide...) -> [OnboardingSlide] {
        components
    }
}

struct AppleOnboardingView<Icon: View, Footer: View>: View {
    var tint: Color
    var slides: [OnboardingSlide]
    var icon: Icon
    var footer: (Color) -> Footer
    @Binding var hasAgreed: Bool
    @Binding var showOnboarding: Bool
    
    init(tint: Color, slides: [OnboardingSlide], @ViewBuilder icon: @escaping () -> Icon, @ViewBuilder footer: @escaping (Color) -> Footer, hasAgreed: Binding<Bool>, showOnboarding: Binding<Bool>) {
        self.tint = tint
        self.slides = slides
        self.icon = icon()
        self.footer = footer
        self._hasAgreed = hasAgreed
        self._showOnboarding = showOnboarding
        self._animateIcon = .init(initialValue: Array(repeating: false, count: slides.count))
        self._animateTitle = .init(initialValue: Array(repeating: false, count: slides.count))
        self._animateCards = .init(initialValue: slides.map { Array(repeating: false, count: $0.cards.count) })
        self._hasAnimated = .init(initialValue: Array(repeating: false, count: slides.count))
    }
    
    // MARK: - Properties
    @State private var currentPage: Int = 0
    @State private var animateIcon: [Bool]
    @State private var animateTitle: [Bool]
    @State private var animateCards: [[Bool]]
    @State private var animateFooterAndButton: Bool = false
    @State private var hasAnimated: [Bool]
    @State private var showAgreement: Bool = false
    
    var body: some View {
        TabView(selection: $currentPage) {
            ForEach(slides.indices, id: \.self) { index in
                ScrollView {
                    VStack(spacing: 25) {
                        icon
                            .frame(maxWidth: .infinity)
                            .blurSlide(animateIcon[index])
                        
                        Text(slides[index].title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .blurSlide(animateTitle[index])
                        
                        ForEach(slides[index].cards.indices, id: \.self) { cardIndex in
                            CardView(card: slides[index].cards[cardIndex], tint: tint)
                                .blurSlide(animateCards[safe: index]?[safe: cardIndex] ?? false)
                        }
                        
                        if index == slides.count - 1 {
                            VStack(spacing: 15) {
                                footer(tint)
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
                    .frame(maxWidth: .infinity)
                    .tag(index)
                }
                .scrollIndicators(.hidden)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .interactiveDismissDisabled()
        .allowsHitTesting(currentPage == slides.count - 1 ? animateFooterAndButton : true)
        .onChange(of: currentPage) { _, newValue in
            guard newValue < slides.count, !(hasAnimated[safe: newValue] ?? false) else { return }
            hasAnimated[newValue] = true
            Task {
                await delayedAnimation(0.2) {
                    animateIcon[newValue] = true
                }
                await delayedAnimation(0.2) {
                    animateTitle[newValue] = true
                }
                for cardIndex in slides[newValue].cards.indices {
                    await delayedAnimation(0.2) {
                        if cardIndex < animateCards[newValue].count {
                            animateCards[newValue][cardIndex] = true
                        }
                    }
                }
                if newValue == slides.count - 1 {
                    await delayedAnimation(0.2) {
                        animateFooterAndButton = true
                    }
                }
            }
        }
        .task {
            guard !(hasAnimated[safe: 0] ?? false) else { return }
            hasAnimated[0] = true
            Task {
                await delayedAnimation(0.2) {
                    animateIcon[0] = true
                }
                await delayedAnimation(0.2) {
                    animateTitle[0] = true
                }
                for cardIndex in slides[0].cards.indices {
                    await delayedAnimation(0.2) {
                        if cardIndex < animateCards[0].count {
                            animateCards[0][cardIndex] = true
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showAgreement) {
            AgreementSheetView(tint: tint, hasAgreed: $hasAgreed) {
                showOnboarding = false
            }
        }
    }
    
    /// Card View
    @ViewBuilder
        func CardView(card: AppleOnboardingCard, tint: Color) -> some View {
            HStack(alignment: .center, spacing: 15) { // Изменили alignment на .center
                Image(systemName: card.symbol)
                    .font(.system(size: 50))
                    .foregroundStyle(tint)
                    .frame(width: 50, height: 50) // Фиксированная ширина и высота для иконки
                    // Убрали .offset(y: 7)
                
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
                .frame(maxWidth: .infinity, alignment: .leading) // Растягиваем текст для единообразия
            }
            .padding(.vertical, 10) // Добавили вертикальный padding для карточки
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity) // Фиксируем ширину карточки
        }
    
    func delayedAnimation(_ delay: Double, action: @escaping () -> ()) async {
        try? await Task.sleep(for: .seconds(delay))
        withAnimation(.smooth) {
            action()
        }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
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
