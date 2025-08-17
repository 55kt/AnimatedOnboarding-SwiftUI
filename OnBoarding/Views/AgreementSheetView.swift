//
//  AgreementSheetView.swift
//  OnBoarding
//
//  Created by Vlad on 17/8/25.
//

import SwiftUI

struct AgreementSheetView: View {
    let tint: Color
    @Binding var hasAgreed: Bool
    let onAccept: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var agreed: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                
                ScrollView {
                    rulesList
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
                }
                .scrollIndicators(.hidden)
                
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
                    .disabled(!agreed)
                }
                .padding(.top, 8)
            }
            .padding(20)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { dismiss() } label: { Image(systemName: "xmark") }
                        .tint(tint)
                }
            }
            .navigationTitle("User Agreement")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AgreementSheetView(tint: .orange, hasAgreed: .constant(true)) {}
}

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
