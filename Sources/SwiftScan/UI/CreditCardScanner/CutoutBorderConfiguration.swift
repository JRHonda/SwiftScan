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
    public var style: RoundedCornerStyle
    public var color: Color
    public var lineWidth: CGFloat
    public var cornerDecoration: CornerDecoration
    
    public static var roundedWhite: Self {
        .init(cornerRadius: 10, style: .continuous, color: .white, lineWidth: 4, cornerDecoration: .rounded)
    }
    
    public static var sharpWhite: Self {
        .init(cornerRadius: 0, style: .continuous, color: .white, lineWidth: 4, cornerDecoration: .rounded)
    }
}
