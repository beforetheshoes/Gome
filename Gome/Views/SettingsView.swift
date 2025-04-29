//
//  SettingsView.swift
//  Gome
//
//  Created by Ryan Williams on 4/28/25.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: UserSettings
    
    @State private var tempOuterColor: Color
    @State private var tempMiddleColor: Color
    @State private var tempInnerColor: Color
    
    // Initialize temp colors based on current settings
    init(settings: UserSettings) {
        _settings = ObservedObject(wrappedValue: settings)
        _tempOuterColor = State(initialValue: settings.customOuterRing)
        _tempMiddleColor = State(initialValue: settings.customMiddleRing)
        _tempInnerColor = State(initialValue: settings.customInnerRing)
    }
    
    var body: some View {
        Form {
            Section {
                Toggle("Dark Mode", isOn: $settings.useDarkMode)
                
                Picker("Color Palette", selection: $settings.selectedPaletteName) {
                    // Built-in palettes
                    ForEach(Palettes.presets, id: \.name) { palette in
                        HStack {
                            PalettePreview(palette: palette)
                            Text(palette.name)
                        }
                        .tag(palette.name)
                    }
                    
                    // Custom option
                    HStack {
                        PalettePreview(palette: settings.customPalette)
                        Text("Custom")
                    }
                    .tag("Custom")
                }
            } footer: {
                Text("Customize the appearance of your app.")
            }
            
            // If user chooses Custom, show color pickers
            if settings.selectedPaletteName == "Custom" {
                Section("Custom Colors") {
                    ColorPicker("Outer Ring", selection: $tempOuterColor)
                        .onChange(of: tempOuterColor) { _, newColor in
                            settings.customOuterRingHex = newColor.hex
                        }
                    ColorPicker("Middle Ring", selection: $tempMiddleColor)
                        .onChange(of: tempMiddleColor) { _, newColor in
                            settings.customMiddleRingHex = newColor.hex
                        }
                    ColorPicker("Inner Ring", selection: $tempInnerColor)
                        .onChange(of: tempInnerColor) { _, newColor in
                            settings.customInnerRingHex = newColor.hex
                        }
                }
            }
        }
        .navigationTitle("Settings")
    }
}

struct PalettePreview: View {
    let palette: ColorPalette
    
    var body: some View {
        ZStack {
            Circle()
                .fill(palette.outerRingColor)
                .frame(width: 24, height: 24)
            Circle()
                .fill(palette.middleRingColor)
                .frame(width: 16, height: 16)
            Circle()
                .fill(palette.innerRingColor)
                .frame(width: 8, height: 8)
        }
    }
}
