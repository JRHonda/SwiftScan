//
//  CutoutBorderConfiguration.swift
//  
//
//  Created by Justin Honda on 5/31/23.
//

import SwiftUI

/// Styles a `RoundedRectangle`
public struct CutoutBorderConfiguration {
    public var cornerRadius: CGFloat = 0
    public var sharpCornerLength: CGFloat = 20
    public var style: RoundedCornerStyle = .continuous
    public var color: Color
    public var lineWidth: CGFloat = 4
    public var cornerDecoration: CornerDecoration = .noDecoration
    public var cornerDecorationColor: Color = .clear
    
    public static var roundedWhite: Self {
        .init(cornerRadius: 10, color: .white)
    }
    
    public static var sharpWhite: Self {
        .init(style: .continuous, color: .white)
    }
}
