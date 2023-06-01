//
//  CutoutBorderConfiguration.swift
//  
//
//  Created by Justin Honda on 5/31/23.
//

import SwiftUI

/// Styles a `RoundedRectangle`
public struct CutoutBorderConfiguration {
    public var cornerRadius: CGFloat
    public var sharpCornerLength: CGFloat
    public var style: RoundedCornerStyle
    public var color: Color
    public var lineWidth: CGFloat
    public var cornerDecoration: CornerDecoration
    public var cornerDecorationColor: Color
    public var textDecorationPosition: TextDecorationPosition
    
    public init(
        cornerRadius: CGFloat = 0,
        sharpCornerLength: CGFloat = 20,
        style: RoundedCornerStyle = .continuous,
        color: Color, lineWidth: CGFloat = 4,
        cornerDecoration: CornerDecoration = .noDecoration,
        cornerDecorationColor: Color = .clear,
        textDecorationPosition: TextDecorationPosition = .below
    ) {
        self.cornerRadius = cornerRadius
        self.sharpCornerLength = sharpCornerLength
        self.style = style
        self.color = color
        self.lineWidth = lineWidth
        self.cornerDecoration = cornerDecoration
        self.cornerDecorationColor = cornerDecorationColor
        self.textDecorationPosition = textDecorationPosition
    }
    
    public static var roundedWhite: Self {
        .init(cornerRadius: 10, color: .white)
    }
    
    public static var sharpWhite: Self {
        .init(style: .continuous, color: .white)
    }
}
