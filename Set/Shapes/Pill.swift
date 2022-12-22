//
//  Pill.swift
//  Set
//
//  Created by Christophe Beaulieu on 2022-12-15.
//

import SwiftUI

struct Pill: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            if rect.width > rect.height {
                let radius = rect.midY
                let leftCenter = CGPoint(x: rect.minX + radius, y: rect.midY)
                let rightCenter = CGPoint(x: rect.maxX - radius, y:rect.midY)

                path.move(to: CGPoint(x: leftCenter.x, y: rect.minY))
                path.addArc(
                    center: leftCenter,
                    radius: radius,
                    startAngle: Angle.degrees(270),
                    endAngle: Angle.degrees(90),
                    clockwise: true
                )
                path.addLine(to: CGPoint(x: rightCenter.x, y: rect.maxY))
                path.addArc(
                    center: rightCenter,
                    radius: radius,
                    startAngle: Angle.degrees(90),
                    endAngle: Angle.degrees(270),
                    clockwise: true
                )
                path.closeSubpath()

            } else if rect.height > rect.width {
                let radius = rect.midY
                let topCenter = CGPoint(x: rect.midX, y: rect.minY + radius)
                let bottomCenter = CGPoint(x: rect.midX, y:rect.maxY - radius)

                path.move(to: CGPoint(x: rect.maxX, y: topCenter.y))
                path.addArc(
                    center: topCenter,
                    radius: radius,
                    startAngle: Angle.degrees(0),
                    endAngle: Angle.degrees(180),
                    clockwise: true
                )
                path.addLine(to: CGPoint(x: rect.minX, y: bottomCenter.y))
                path.addArc(
                    center: bottomCenter,
                    radius: radius,
                    startAngle: Angle.degrees(180),
                    endAngle: Angle.degrees(0),
                    clockwise: true
                )
                path.closeSubpath()

            } else /* rect.height == rect.width */ {
                let radius = rect.midX
                path.addArc(
                    center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: radius,
                    startAngle: Angle.degrees(0),
                    endAngle: Angle.degrees(360),
                    clockwise: true)
            }
        }
    }
}
