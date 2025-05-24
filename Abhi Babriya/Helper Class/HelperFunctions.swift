//
//  HelperFunctions.swift
//  Abhi Babriya
//
//  Created by Abhi Babriya on 24/05/25.
//

import Foundation
import UIKit

func formatDateString(_ isoDateString: String) -> String? {
    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    if let date = isoFormatter.date(from: isoDateString) {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMMM yyyy"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        return outputFormatter.string(from: date)
    }
    return nil
}

func applyForegroundColorToHashtags(in text: String, withColor color: UIColor, font: UIFont? = nil) -> NSAttributedString {
    // Default attributes with white color for non-hashtag text
    let attributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.white,
        .font: font ?? UIFont.systemFont(ofSize: 12) // Provide default font if not passed
    ]
    let attributedString = NSMutableAttributedString(string: text, attributes: attributes)

    // Regex pattern to match all words starting with #
    let pattern = "(?<!\\w)#\\w+"

    // Use regex to find and color all hashtags
    if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
        let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        for match in matches {
            attributedString.addAttribute(.foregroundColor, value: color, range: match.range)
        }
    }

    return attributedString
}
