//
//  VNConfidence+Extensions.swift
//  
//
//  Created by Justin Honda on 5/31/23.
//

import SwiftUI
import Vision

extension VNConfidence {
    
    var borderColor: Color {
        switch self {
        case 0.1..<0.3: return .red
        case 0.3..<0.5: return .yellow
        case 0.5...1: return .green
        default: return .white
        }
    }
    
}
