//
//  SliceShape.swift
//  Gome
//
//  Created by Ryan Williams on 4/26/25.
//

import SwiftUI

struct SliceShape: Shape {
    let totalSlices: Int
    let sliceIndex: Int
    let thickness: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let innerRadius = radius - thickness
        
        let startAngle = Angle.degrees(Double(sliceIndex) / Double(totalSlices) * 360 - 90)
        let endAngle = Angle.degrees(Double(sliceIndex + 1) / Double(totalSlices) * 360 - 90)
        
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.addArc(center: center, radius: innerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: true)
        path.closeSubpath()
        
        return path
    }
}
