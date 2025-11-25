//
//  TextLayer.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros <skippyr.developer@icloud.com>
//  Visit my website: https://dragonscave.xyz.
//  Follow me on GitHub: https://github.com/skippyr.
//
//  Refer to the LICENSE file that comes in its source code for more details.
//  If not available, all rights are reserved to the author.
//

/// Contains the terminal text layers where colors can be applied to.
public enum TextLayer {
    /// Affects the color of the characters.
    case foreground
    /// Affects the background color behind the characters.
    case background

    var ansi: UInt8 {
        switch self {
        case .foreground:
            3
        case .background:
            4
        }
    }
}
