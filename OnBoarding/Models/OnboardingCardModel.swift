//
//  OnboardingCardModel.swift
//  OnBoarding
//
//  Created by Vlad on 17/8/25.
//

import Foundation

struct OnboardingCard: Identifiable {
    var id: String = UUID().uuidString
    var symbol: String
    var title: String
    var subtitle: String
}
