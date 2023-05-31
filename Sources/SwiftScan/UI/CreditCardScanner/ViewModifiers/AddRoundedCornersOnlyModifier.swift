//
//  AddRoundedCornersOnlyModifier.swift
//  
//
//  Created by Justin Honda on 5/31/23.
//

import SwiftUI

struct AddRoundedCornersOnlyModifier: ViewModifier {
    private let cornerRadius: CGFloat
    private let color: Color
    private let lineWidth: CGFloat
    private let size: CGSize
    private let position: CGPoint
    
    init(cornerRadius: CGFloat, color: Color, lineWidth: CGFloat, size: CGSize, position: CGPoint) {
        self.cornerRadius = cornerRadius
        self.color = color
        self.lineWidth = lineWidth
        self.size = size
        self.position = position
    }
    
    func body(content: Content) -> some View {
        content.overlay {
            VStack {
                HStack {
                    makeRoundedCorner(for: .rounded(.topLeft))
                    Spacer()
                    makeRoundedCorner(for: .rounded(.topRight))
                }
                Spacer()
                HStack {
                    makeRoundedCorner(for: .rounded(.bottomLeft))
                    Spacer()
                    makeRoundedCorner(for: .rounded(.bottomRight))
                }
            }
            .frame(width: size.width, height: size.height)
            .position(position)
        }
    }
    
    private var length: CGFloat {
        cornerRadius * 2
    }
    
    private func makeRoundedCorner(for corner: Corner) -> some View {
        Circle()
            .trim(from: 0.0, to: 0.25)
            .stroke(color, lineWidth: lineWidth)
            .frame(width: length, height: length)
            .rotationEffect(corner.rotationAngle)
    }
}
