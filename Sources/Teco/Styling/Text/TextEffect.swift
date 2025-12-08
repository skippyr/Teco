//
//  File: TextEffect.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros (skippyr.developer@icloud.com)
//  Connect: https://dragonscave.xyz | GitHub: https://github.com/skippyr
//
//  Refer to the LICENSE file included with this source code for full terms.
//  See the NOTICE file, if included, for third-party attributions.
//

/// Contains the most widely supported terminal text effects.
public enum TextEffect {
    /// Makes the text use italic font.
    case italic
    /// Draws a horizontal line below the text.
    case underline
    @available(*, deprecated, renamed: "blink")
    case blinking
    /// Makes the text blink in slow pace.
    case blink
    @available(*, deprecated, renamed: "swapLayers")
    case invertedLayers
    /// Swaps the foreground and background layers, affecting where colors are applied.
    case swapLayers
    /// Draws a horizontal line through the text.
    case strikethrough

    var ansi: UInt8 {
        switch self {
        case .italic:
            3
        case .underline:
            4
        case .blinking, .blink:
            5
        case .invertedLayers, .swapLayers:
            7
        case .strikethrough:
            9
        }
    }
}
