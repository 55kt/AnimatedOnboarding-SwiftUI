//
//  OnboardingView.swift
//  OnBoarding
//
//  Created by Vlad on 17/8/25.
//

import SwiftUI

struct OnboardingView<Icon: View, Footer: View>: View {
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
                            .blurSlide(animateIcon[safe: index] ?? false)
                        
                        Text(slides[index].title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .blurSlide(animateTitle[safe: index] ?? false)
                        
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
                    if newValue < animateIcon.count {
                        animateIcon[newValue] = true
                    }
                }
                await delayedAnimation(0.2) {
                    if newValue < animateTitle.count {
                        animateTitle[newValue] = true
                    }
                }
                for cardIndex in slides[newValue].cards.indices {
                    await delayedAnimation(0.2) {
                        if newValue < animateCards.count && cardIndex < animateCards[newValue].count {
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
                    if 0 < animateIcon.count {
                        animateIcon[0] = true
                    }
                }
                await delayedAnimation(0.2) {
                    if 0 < animateTitle.count {
                        animateTitle[0] = true
                    }
                }
                for cardIndex in slides[0].cards.indices {
                    await delayedAnimation(0.2) {
                        if 0 < animateCards.count && cardIndex < animateCards[0].count {
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
    
    func delayedAnimation(_ delay: Double, action: @escaping () -> ()) async {
        try? await Task.sleep(for: .seconds(delay))
        withAnimation(.smooth) {
            action()
        }
    }
}

#Preview {
    ContentView()
}
