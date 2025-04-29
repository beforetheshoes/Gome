//
//  RingView.swift
//  Gome
//
//  Created by Ryan Williams on 4/26/25.
//

import SwiftUI

struct RingView: View {
    @ObservedObject var settings: UserSettings
    let slices: [Bool]
    let ringWidth: CGFloat
    let radius: CGFloat
    let ringPosition: RingPosition

    enum RingPosition {
        case outer, middle, inner
    }

    var ringColor: Color {
        let palette = settings.selectedPalette
        switch ringPosition {
        case .outer: return palette.outerRingColor
        case .middle: return palette.middleRingColor
        case .inner: return palette.innerRingColor
        }
    }

    var body: some View {
        ZStack {
            ForEach(0..<slices.count, id: \.self) { index in
                SliceShape(
                    totalSlices: slices.count,
                    sliceIndex: index,
                    thickness: ringWidth
                )
                .fill(slices[index] ? ringColor : Color.secondary.opacity(0.2))
            }
        }
        .frame(width: radius * 2, height: radius * 2)
    }
}
