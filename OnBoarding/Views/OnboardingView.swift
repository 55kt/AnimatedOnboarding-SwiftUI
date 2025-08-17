//
//  OnboardingView.swift
//  OnBoarding
//
//  Created by Vlad on 17/8/25.
//

import SwiftUI

/// Paged onboarding with staged animations:
/// - Per-page hero icon + title + a list of cards (benefits)
/// - Footer + Continue button only on the last page
/// - External bindings decide when onboarding is finished (`hasAgreed`, `showOnboarding`)
struct OnboardingView<Icon: View, Footer: View>: View {
    /// Accent color used for icons/buttons inside onboarding
    var tint: Color

    /// Data source for pages (title + cards per page)
    var slides: [OnboardingSlide]

    /// Top "hero" view rendered on each page (kept simple for perf)
    var icon: Icon

    /// Footer builder (receives `tint`), rendered on the last page above the Continue button
    var footer: (Color) -> Footer

    /// Set to `true` when user accepts the Agreement in the sheet (owner of this view decides how to persist)
    @Binding var hasAgreed: Bool

    /// Controls presentation of the onboarding container (owner toggles it off when done)
    @Binding var showOnboarding: Bool

    /// Designated init to prepare per-page animation state arrays sized to `slides`
    init(
        tint: Color,
        slides: [OnboardingSlide],
        @ViewBuilder icon: @escaping () -> Icon,
        @ViewBuilder footer: @escaping (Color) -> Footer,
        hasAgreed: Binding<Bool>,
        showOnboarding: Binding<Bool>
    ) {
        self.tint = tint
        self.slides = slides
        self.icon = icon()
        self.footer = footer
        self._hasAgreed = hasAgreed
        self._showOnboarding = showOnboarding

        // Pre-size animation flags so we can address by page/card index safely
        self._animateIcon  = .init(initialValue: Array(repeating: false, count: slides.count))
        self._animateTitle = .init(initialValue: Array(repeating: false, count: slides.count))
        self._animateCards = .init(initialValue: slides.map { Array(repeating: false, count: $0.cards.count) })
        self._hasAnimated  = .init(initialValue: Array(repeating: false, count: slides.count))
    }

    // MARK: - State

    /// Current page index inside the TabView
    @State private var currentPage: Int = 0

    /// Per-page staged animation flags (icon → title → cards)
    @State private var animateIcon: [Bool]
    @State private var animateTitle: [Bool]
    @State private var animateCards: [[Bool]]

    /// Footer + Continue button appear only on the last page
    @State private var animateFooterAndButton: Bool = false

    /// Guard to run entry animations only once per page
    @State private var hasAnimated: [Bool]

    /// Controls the Agreement sheet presentation
    @State private var showAgreement: Bool = false

    var body: some View {
        TabView(selection: $currentPage) {
            ForEach(slides.indices, id: \.self) { index in
                // Note: ScrollView allows content to breathe on smaller devices.
                // If all content fits, List/VStack is fine too.
                ScrollView {
                    VStack(spacing: 25) {
                        // 1) Hero
                        icon
                            .frame(maxWidth: .infinity)
                            .blurSlide(animateIcon[safe: index] ?? false)

                        // 2) Title
                        Text(slides[index].title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .blurSlide(animateTitle[safe: index] ?? false)

                        // 3) Cards (benefits/features per page)
                        ForEach(slides[index].cards.indices, id: \.self) { cardIndex in
                            CardView(card: slides[index].cards[cardIndex], tint: tint)
                                .blurSlide(animateCards[safe: index]?[safe: cardIndex] ?? false)
                        }

                        // 4) Last page footer + Continue
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
                    .tag(index) // bind each page to its index for TabView selection
                }
                .scrollIndicators(.hidden)
            }
        }
        .tabViewStyle(.page) // native paged dots
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .interactiveDismissDisabled() // prevent swiping the sheet away mid-flow if presented modally

        // Disable interaction on the last page until footer/button finish animating (prevents premature taps)
        .allowsHitTesting(currentPage == slides.count - 1 ? animateFooterAndButton : true)

        // Drive per-page staged animations when the user lands on a new page
        .onChange(of: currentPage) { _, new in
            guard new < slides.count, !(hasAnimated[safe: new] ?? false) else { return }
            hasAnimated[new] = true

            Task {
                // Icon → Title → Cards (staggered)
                await delayedAnimation(0.2) { animateIcon[new] = true }
                await delayedAnimation(0.2) { animateTitle[new] = true }

                for i in slides[new].cards.indices {
                    await delayedAnimation(0.2) {
                        animateCards[new][i] = true
                    }
                }

                // Footer/Button only for the last page
                if new == slides.count - 1 {
                    await delayedAnimation(0.2) { animateFooterAndButton = true }
                }
            }
        }

        // Kick off entry animation for the first page
        .task {
            guard !(hasAnimated[safe: 0] ?? false) else { return }
            hasAnimated[0] = true
            Task {
                await delayedAnimation(0.2) { if 0 < animateIcon.count { animateIcon[0] = true } }
                await delayedAnimation(0.2) { if 0 < animateTitle.count { animateTitle[0] = true } }
                for cardIndex in slides[0].cards.indices {
                    await delayedAnimation(0.2) {
                        if 0 < animateCards.count && cardIndex < animateCards[0].count {
                            animateCards[0][cardIndex] = true
                        }
                    }
                }
            }
        }

        // Agreement sheet: toggled by Continue button on the last page
        .sheet(isPresented: $showAgreement) {
            // AgreementSheetView is expected to set `hasAgreed = true` internally before calling onAccept
            AgreementSheetView(tint: tint, hasAgreed: $hasAgreed) {
                // Owner decides what "finish" means; here we just hide onboarding.
                showOnboarding = false
            }
        }
    }

    /// Async helper to stage animations with a delay.
    /// Uses `.smooth` timing; swap for `.easeInOut` if you prefer stricter curves or older iOS.
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
