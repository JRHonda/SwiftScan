//
//  VerticalPlacement.swift
//  
//
//  Created by Justin Honda on 5/31/23.
//

import Foundation

public enum VerticalPlacement {
    case center
    /// { 0, 1 } center point
    case fraction(CGFloat)
    
    var value: CGFloat {
        switch self {
        case .center: return 0.5
        case .fraction(let fraction):
            if fraction <= 0 {
                return 0.01
            }
            if fraction > 1 {
                return 1
            }
            return fraction
        }
    }
}
