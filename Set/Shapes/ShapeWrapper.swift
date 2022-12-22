//
//  ShapeWrapper.swift
//  Set
//
//  Created by Christophe Beaulieu on 2022-12-22.
//

import SwiftUI

struct ShapeWrapper: Shape {
    init<S: Shape>(_ wrapped: S) {
        _path = { rect in wrapped.path(in: rect) }
    }

    func path(in rect: CGRect) -> Path {
        _path(rect)
    }

    private let _path: (CGRect) -> Path
}

struct ShapeWrapper_Previews: PreviewProvider {
    static var previews: some View {
        let shapes = [
            ShapeWrapper(Pill()),
            ShapeWrapper(Diamond()),
            ShapeWrapper(Squiggle()),
            ShapeWrapper(Pill()),
            ShapeWrapper(Diamond()),
            ShapeWrapper(Squiggle()),
        ]
        let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple]
        let width: CGFloat = 200
        
        VStack {
            ForEach(Array(0..<shapes.count), id: \.self) { index in
                shapes[index]
                    .foregroundColor(colors[index % colors.count])
            }
            .frame(width: width, height: width / 2)
            .padding()
        }
    }
}
