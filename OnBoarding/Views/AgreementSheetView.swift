//
//  AgreementSheetView.swift
//  OnBoarding
//
//  Created by Vlad on 17/8/25.
//

import SwiftUI

/// Terms & Privacy consent sheet.
/// - Presents a lightweight list of rules.
/// - Requires explicit toggle before enabling the primary action.
/// - Propagates acceptance via `hasAgreed` binding and `onAccept` callback.
/// - Designed to be presented as a sheet from the last onboarding slide.
struct AgreementSheetView: View {
    /// Accent color for controls inside the sheet.
    let tint: Color

    /// External agreement flag (owner decides how/where to persist, e.g. @AppStorage).
    @Binding var hasAgreed: Bool

    /// Invoked after acceptance (e.g. to dismiss onboarding or proceed to auth).
    let onAccept: () -> Void

    /// Sheet dismisser from environment (kept for Cancel/X).
    @Environment(\.dismiss) private var dismiss

    /// Local UI state for the consent toggle (gate for enabling the CTA button).
    @State private var agreed: Bool = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {

                // Scrollable rules block; keep typography neutral and non-distracting.
                ScrollView {
                    rulesList
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }
                .scrollIndicators(.hidden)

                // Explicit consent toggle (legal-friendly and UX-clear).
                Toggle(isOn: $agreed) {
                    Text("I have read and agree to the Terms and Privacy Policy.")
                }
                .toggleStyle(.switch)
                .tint(tint)
                .padding(.top, 4)

                // Action row: secondary Cancel + primary Accept.
                HStack {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(.secondary)

                    Spacer()

                    Button {
                        // Surface consent upstream and let the owner drive next steps.
                        hasAgreed = true
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
                    .disabled(!agreed) // prevent proceeding without explicit consent
                }
                .padding(.top, 8)
            }
            .padding(20)
            .toolbar {
                // Close affordance in the nav bar (mirrors Cancel).
                ToolbarItem(placement: .topBarTrailing) {
                    Button { dismiss() } label: { Image(systemName: "xmark") }
                        .tint(tint)
                        .accessibilityLabel("Close")
                }
            }
            .navigationTitle("User Agreement")
            .navigationBarTitleDisplayMode(.inline)
        }
        // Consider `.presentationDetents([.medium, .large])` at call site if you want fixed heights.
    }
}

#Preview {
    AgreementSheetView(tint: .orange, hasAgreed: .constant(true)) { }
}

/// Static rules content used inside the agreement sheet.
/// Keep this self-contained for reuse/testing; migrate to localized strings for production.
private var rulesList: some View {
    VStack(alignment: .leading, spacing: 12) {
        Text("• Public data: nickname, amounts, and timestamps may appear on the leaderboard.")
        Text("• No gambling or prizes. This is a status-based leaderboard experience.")
        Text("• We store minimal data and respect your privacy.")
        Text("• By continuing, you agree to our Terms of Use and Privacy Policy.")
        Text("• Cheating, exploiting bugs, or unfair play may result in removal from the leaderboard.")
        Text("• Usernames must be appropriate and respectful to all audiences.")
        Text("• Data is securely stored and never sold to third parties.")
        Text("• Offensive behavior or harassment will not be tolerated.")
    }
}
