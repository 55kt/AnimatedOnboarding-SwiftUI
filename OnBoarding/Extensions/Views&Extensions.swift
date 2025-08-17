//
//  Views&Extensions.swift
//  OnBoarding
//
//  Created by Vlad on 17/8/25.
//

import SwiftUI

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
