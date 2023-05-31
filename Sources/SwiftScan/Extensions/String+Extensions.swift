//
//  String+Extensions.swift
//  
//
//  Created by Justin Honda on 5/31/23.
//

import Foundation

extension String {
    
    var digitized: String {
        let charSet = CharacterSet.decimalDigits.inverted
        return components(separatedBy: charSet).joined()
    }
    
}
