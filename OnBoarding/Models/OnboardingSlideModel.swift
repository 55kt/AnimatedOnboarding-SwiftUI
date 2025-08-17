//
//  OnboardingSlideModel.swift
//  OnBoarding
//
//  Created by Vlad on 17/8/25.
//

import Foundation

struct OnboardingSlide {
    var title: String
    var cards: [OnboardingCard]
}

@resultBuilder
struct OnboardingSlideResultBuilder {
    static func buildBlock(_ components: OnboardingSlide...) -> [OnboardingSlide] {
        components
    }
}
