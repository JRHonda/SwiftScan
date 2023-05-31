//
//  AddSharpCornersOnlyModifier.swift
//  
//
//  Created by Justin Honda on 5/31/23.
//

import SwiftUI

struct AddSharpCornersOnlyModifier: ViewModifier {
    private let length: CGFloat
    private let color: Color
    private let lineWidth: CGFloat
    private let size: CGSize
    private let position: CGPoint
    
    init(length: CGFloat, color: Color, lineWidth: CGFloat, size: CGSize, position: CGPoint) {
        self.length = length
        self.color = color
        self.lineWidth = lineWidth
        self.size = size
        self.position = position
    }
    
    func body(content: Content) -> some View {
        content.overlay {
            VStack {
                HStack {
                    makeSharpCorner(for: .sharp(.topLeft))
                    Spacer()
                    makeSharpCorner(for: .sharp(.topRight))
                }
                Spacer()
                HStack {
                    makeSharpCorner(for: .sharp(.bottomLeft))
                    Spacer()
                    makeSharpCorner(for: .sharp(.bottomRight))
                }
            }
            .frame(width: size.width, height: size.height)
            .position(position)
        }
    }
    
    private func makeSharpCorner(for corner: Corner) -> some View {
        Rectangle()
            .trim(from: 0.0, to: 0.5)
            .stroke(color, lineWidth: lineWidth)
            .frame(width: length, height: length)
            .rotationEffect(corner.rotationAngle)
    }
}
