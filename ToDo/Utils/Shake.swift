//
//  Shake.swift
//  ToDo
//
//  Created by LXL on 2025/10/31.
//

import Foundation
import SwiftUI

struct ShakeEffect: GeometryEffect {
    var shakes: CGFloat
    
    var animatableData: CGFloat {
        get { shakes }
        set { shakes = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = 10 * sin(shakes * .pi * 2)
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}
