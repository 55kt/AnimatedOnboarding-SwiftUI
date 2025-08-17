//
//  Array&Extensions.swift
//  OnBoarding
//
//  Created by Vlad on 17/8/25.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
