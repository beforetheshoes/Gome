//
//  UserSettings.swift
//  Gome
//
//  Created by Ryan Williams on 4/28/25.
//

import SwiftUI

class UserSettings: ObservableObject {
    // Regular settings
    @Published var useDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(useDarkMode, forKey: "useDarkMode")
        }
    }

    @Published var selectedPaletteName: String {
        didSet {
            UserDefaults.standard.set(selectedPaletteName, forKey: "selectedPaletteName")
            
            if selectedPaletteName != "Custom",
               let preset = Palettes.presets.first(where: { $0.name == selectedPaletteName }) {
                customOuterRingHex = preset.outerRingColor.hex
                customMiddleRingHex = preset.middleRingColor.hex
                customInnerRingHex = preset.innerRingColor.hex
            }
        }
    }

    @Published var customOuterRingHex: Int {
        didSet {
            UserDefaults.standard.set(customOuterRingHex, forKey: "customOuterRing")
        }
    }

    @Published var customMiddleRingHex: Int {
        didSet {
            UserDefaults.standard.set(customMiddleRingHex, forKey: "customMiddleRing")
        }
    }

    @Published var customInnerRingHex: Int {
        didSet {
            UserDefaults.standard.set(customInnerRingHex, forKey: "customInnerRing")
        }
    }

    // Computed Color properties
    var customOuterRing: Color {
        Color(hex: UInt(customOuterRingHex))
    }

    var customMiddleRing: Color {
        Color(hex: UInt(customMiddleRingHex))
    }

    var customInnerRing: Color {
        Color(hex: UInt(customInnerRingHex))
    }

    var customPalette: ColorPalette {
        ColorPalette(
            name: "Custom",
            outerRingColor: customOuterRing,
            middleRingColor: customMiddleRing,
            innerRingColor: customInnerRing
        )
    }

    var selectedPalette: ColorPalette {
        if selectedPaletteName == "Custom" {
            return customPalette
        } else {
            return Palettes.presets.first(where: { $0.name == selectedPaletteName }) ?? Palettes.presets.first!
        }
    }

    init() {
        self.useDarkMode = UserDefaults.standard.bool(forKey: "useDarkMode")
        self.selectedPaletteName = UserDefaults.standard.string(forKey: "selectedPaletteName") ?? "Gome"
        self.customOuterRingHex = UserDefaults.standard.object(forKey: "customOuterRing") as? Int ?? 0x36a4f5
        self.customMiddleRingHex = UserDefaults.standard.object(forKey: "customMiddleRing") as? Int ?? 0xf5d44f
        self.customInnerRingHex = UserDefaults.standard.object(forKey: "customInnerRing") as? Int ?? 0xd528fe
    }

    func updatePalette(_ palette: ColorPalette) {
        selectedPaletteName = palette.name
    }
}

extension UserSettings {
    static let shared = UserSettings()
}
