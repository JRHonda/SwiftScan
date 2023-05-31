//
//  Enums.swift
//  
//
//  Created by Justin Honda on 5/31/23.
//

import SwiftUI

public enum CornerDecoration {
    case sharp, rounded, noDecoration
}

public enum Corner {
    case sharp(Position)
    case rounded(Position)
    
    public enum Position {
        case topLeft, topRight, bottomRight, bottomLeft
    }
    
    var rotationAngle: Angle {
        switch self {
        case let .sharp(position):
            switch position {
            case .topLeft:
                return .degrees(270)
            case .topRight:
                return .degrees(0)
            case .bottomRight:
                return .degrees(90)
            case .bottomLeft:
                return .degrees(180)
            }
        case let .rounded(position):
            switch position {
            case .topLeft:
                return .degrees(180)
            case .topRight:
                return .degrees(270)
            case .bottomRight:
                return .degrees(0)
            case .bottomLeft:
                return .degrees(90)
            }
        }
    }
}
