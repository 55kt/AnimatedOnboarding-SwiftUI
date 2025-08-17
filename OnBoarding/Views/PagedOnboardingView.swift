//
//  PagedOnboardingView.swift
//  OnBoarding
//
//  Created by Vlad on 17/8/25.
//

import SwiftUI
import AuthenticationServices

// MARK: - Model for paged onboarding
struct OnboardingPage: Identifiable, Equatable {
    let id = UUID()
    let symbol: String
    let title: String
    let subtitle: String
}

// MARK: - Paged Onboarding with 3 slides + Agreement sheet on the last one
struct PagedOnboardingView: View {
    let tint: Color
    let pages: [OnboardingPage]
    let onFinish: () -> Void       // call when user agrees & finishes

    @State private var current = 0
    @State private var showAgreement = false

    // per-page animation flags (re-use your blurSlide approach)
    @State private var animateIcon = false
    @State private var animateTitle = false
    @State private var animateSubtitle = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $current) {
                ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                    slide(page)
                        .tag(index)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: 330)
                        .task {
                            // перезапуск анимаций при показе слайда
                            guard current == index else { return }
                            await runPageAnimations()
                        }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .onChange(of: current) {_, _ in
                // сбрасываем флаги при смене страницы, чтобы анимации повторялись
                resetAnimations()
            }

            // Footer: only on last page – show Continue button
            if current == pages.count - 1 {
                VStack(spacing: 12) {
                    // маленький поясняющий текст
                    Text("By continuing you accept the Terms and Privacy Policy.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)

                    Button {
                        showAgreement = true
                    } label: {
                        Text("Continue")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(tint)
                    .buttonBorderShape(.capsule)
                    .padding(.horizontal, 20)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
                .padding(.top, 16)
                .padding(.bottom, 10)
                .blurSlide(true) // твой эффект — просто показываем без задержек
            }
        }
        .interactiveDismissDisabled()
        .sheet(isPresented: $showAgreement) {
            AgreementSheet(tint: tint) {
                showAgreement = false
                onFinish()
            }
        }
    }

    // MARK: - Single slide view (reuse your blurSlide)
    private func slide(_ page: OnboardingPage) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            Image(systemName: page.symbol)
                .font(.system(size: 48, weight: .semibold))
                .foregroundStyle(tint)
                .frame(maxWidth: .infinity, alignment: .center)
                .blurSlide(animateIcon)

            Text(page.title)
                .font(.title2).fontWeight(.bold)
                .blurSlide(animateTitle)

            Text(page.subtitle)
                .font(.callout)
                .foregroundStyle(.secondary)
                .blurSlide(animateSubtitle)

            Spacer(minLength: 0)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }

    // MARK: - Animations
    private func resetAnimations() {
        animateIcon = false
        animateTitle = false
        animateSubtitle = false
    }

    private func runPageAnimations() async {
        if reduceMotion {
            // без движения — просто показываем
            animateIcon = true; animateTitle = true; animateSubtitle = true
            return
        }
        await delayed(0.20) { animateIcon = true }
        await delayed(0.15) { animateTitle = true }
        await delayed(0.15) { animateSubtitle = true }
    }

    private func delayed(_ delay: Double, _ action: @escaping () -> Void) async {
        try? await Task.sleep(for: .seconds(delay))
        withAnimation(.smooth) { action() }
    }
}

// MARK: - Agreement Sheet (checkbox + actions)
private struct AgreementSheet: View {
    let tint: Color
    let onAccept: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var agreed = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("User Agreement")
                    .font(.title2).bold()

                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("• Public data: nickname, amounts, and timestamps may appear on the leaderboard.")
                        Text("• No gambling or prizes. This is a status-based leaderboard experience.")
                        Text("• We store minimal data and respect your privacy.")
                        Text("• By continuing, you agree to our Terms of Use and Privacy Policy.")
                    }
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
                }

                Toggle(isOn: $agreed) {
                    Text("I have read and agree to the Terms and Privacy Policy.")
                }
                .toggleStyle(.switch)
                .tint(tint)
                .padding(.top, 4)

                HStack {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(.secondary)

                    Spacer()

                    Button {
                        onAccept()
                    } label: {
                        Text("Accept & Continue")
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(tint)
                    .buttonBorderShape(.capsule)
                    .disabled(!agreed)
                }
                .padding(.top, 8)
            }
            .padding(20)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
