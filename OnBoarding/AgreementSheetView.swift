//
//  AgreementSheetView.swift
//  OnBoarding
//
//  Created by Vlad on 17/8/25.
//

import SwiftUI

struct AgreementSheetView: View {
    let tint: Color
    let onAccept: () -> Void
    @Environment(\.dismiss) private var dismiss
    @AppStorage("hasAgreedToTerms") private var hasAgreed: Bool = false
    @State private var agreed: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("User Agreement").font(.title2).bold()
                
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
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

#Preview {
    AgreementSheetView(tint: .orange) {}
}
