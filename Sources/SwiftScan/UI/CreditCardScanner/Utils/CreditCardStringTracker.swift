//
//  CreditCardStringTracker.swift
//  
//
//  Created by Justin Honda on 5/31/23.
//

import Foundation

/// Credit: Apple via https://developer.apple.com/documentation/vision/extracting_phone_numbers_from_text_in_images
final class CreditCardStringTracker {
    var frameIndex: Int64 = 0

    typealias StringObservation = (lastSeen: Int64, count: Int64)
    
    // The dictionary of seen strings, used to get stable recognition before
    // displaying anything.
    var seenStrings = [String: StringObservation]()
    var bestCount = Int64(0)
    var bestString = ""

    func logFrame(strings: [String]) {
        for string in strings {
            if seenStrings[string] == nil {
                seenStrings[string] = (lastSeen: Int64(0), count: Int64(-1))
            }
            seenStrings[string]?.lastSeen = frameIndex
            seenStrings[string]?.count += 1
            print("Seen \(string) \(seenStrings[string]?.count ?? 0) times")
        }
    
        var obsoleteStrings = [String]()

        // Prune old strings and identify the non-pruned string with the
        // greatest count.
        for (string, obs) in seenStrings {
            // Add text not seen in the last 30 frames (~1s) to the
            // obsolete strings array.
            if obs.lastSeen < frameIndex - 30 {
                obsoleteStrings.append(string)
            }
            
            // Find the string with the greatest count.
            let count = obs.count
            if !obsoleteStrings.contains(string) && count > bestCount {
                bestCount = Int64(count)
                bestString = string
            }
        }
        // Remove old strings.
        for string in obsoleteStrings {
            seenStrings.removeValue(forKey: string)
        }
        
        frameIndex += 1
    }
    
    func getStableString() -> String? {
        // Require the recognizer to see the same string at least 10 times.
        if bestCount >= 10 {
            return bestString
        } else {
            return nil
        }
    }
    
    func reset(string: String) {
        seenStrings.removeValue(forKey: string)
        bestCount = 0
        bestString = ""
    }
}
