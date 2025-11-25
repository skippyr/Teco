//
//  TextEffect.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros <skippyr.developer@icloud.com>
//  Visit my website: https://dragonscave.xyz.
//  Follow me on GitHub: https://github.com/skippyr.
//
//  Refer to the LICENSE file that comes in its source code for more details.
//  If not available, all rights are reserved to the author.
//

/// Contains the most widely supported terminal text effects.
public enum TextEffect {
    /// Makes the text use italic font.
    case italic
    /// Draws a horizontal line below the text.
    case underline
    /// Makes the text blink in slow pace.
    case blinking
    /// Inverts the colors used on the foreground and background layers.
    case invertedLayers
    /// Draws a horizontal line through the text.
    case strikethrough

    var ansi: UInt8 {
        switch self {
        case .italic:
            3
        case .underline:
            4
        case .blinking:
            5
        case .invertedLayers:
            7
        case .strikethrough:
            9
        }
    }
}
