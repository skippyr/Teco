//
//  File: TextLayer.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros (skippyr.developer@icloud.com)
//  Connect: https://dragonscave.xyz | GitHub: https://github.com/skippyr
//
//  Refer to the LICENSE file included with this source code for full terms.
//  See the NOTICE file, if included, for third-party attributions.
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
