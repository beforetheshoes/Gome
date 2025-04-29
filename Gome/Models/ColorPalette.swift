//
//  ColorPalette.swift
//  Gome
//
//  Created by Ryan Williams on 4/28/25.
//

import SwiftUI

struct ColorPalette: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var outerRingColor: Color
    var middleRingColor: Color
    var innerRingColor: Color
}

struct Palettes {
    static let presets: [ColorPalette] = [
        ColorPalette(
            name: "Gome",
            outerRingColor: Color(hex: 0x36a4f5),
            middleRingColor: Color(hex: 0xf5d44f),
            innerRingColor: Color(hex: 0xd528fe)
        ),
        ColorPalette(name: "Sunset", outerRingColor: .red, middleRingColor: .orange, innerRingColor: .yellow),
        ColorPalette(name: "Ocean Breeze", outerRingColor: .blue, middleRingColor: .teal, innerRingColor: .mint),
        ColorPalette(name: "Forest", outerRingColor: .green, middleRingColor: .yellow, innerRingColor: .brown),
        ColorPalette(name: "Midnight", outerRingColor: .indigo, middleRingColor: .purple, innerRingColor: .black),
        ColorPalette(name: "Pastels", outerRingColor: .pink, middleRingColor: .mint, innerRingColor: .purple)
        // Add more presets later
    ]
}
