//
//  Stripes.swift
//  Set
//
//  Created by Christophe Beaulieu on 2022-12-22.
//

import SwiftUI

struct Stripes: View {
    
    // TODO: It could be interesting to have an angle, where the lines would be drawn with that angle instead of always being vertical
    
    var lineWidth: CGFloat = 1
    var lineSpacing: CGFloat = 3

    var body: some View {
        _Stripes(lineSpacing: lineSpacing)
            .stroke(lineWidth: lineWidth)
    }
    
    private struct _Stripes: Shape {
        var lineSpacing: CGFloat
        
        func path(in rect: CGRect) -> Path {
            Path { path in
                var x: CGFloat = lineSpacing / 2
                repeat {
                    path.move(to: CGPoint(x: rect.midX - x, y: rect.minY))
                    path.addLine(to: CGPoint(x: rect.midX - x, y: rect.maxY))
                    path.move(to: CGPoint(x: rect.midX + x, y: rect.minY))
                    path.addLine(to: CGPoint(x: rect.midX + x, y: rect.maxY))
                    x += lineSpacing
                } while x < rect.midX
            }
        }
    }
}

struct Stripes_Previews: PreviewProvider {
    static var previews: some View {

        let rect = RoundedRectangle(cornerRadius: 5)
        let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple]
        
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
            ForEach(Array(0..<18), id: \.self) { index in
                ZStack {
                    let colIndex = index % 3
                    let rowIndex = index / 3
                    let color = colors[rowIndex]
                    Stripes(
                        lineWidth: CGFloat(colIndex + 1) * 2,
                        lineSpacing: CGFloat(rowIndex + 3) * 3
                    )
                    .clipShape(rect)
                    .foregroundColor(color)
                    
                    rect.stroke(.secondary)
                }
                .frame(height: 100)
            }
            .padding(8)
        }
        .padding()
        .preferredColorScheme(.dark)
    }
}
