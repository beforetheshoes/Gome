//
//  Color+Extensions.swift
//  Gome
//
//  Created by Ryan Williams on 4/28/25.
//

import SwiftUI
import UIKit

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
    
    var hex: Int {
        let uiColor = UIColor(self)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)

        return (Int(red * 255) << 16) | (Int(green * 255) << 8) | Int(blue * 255)
    }
}
