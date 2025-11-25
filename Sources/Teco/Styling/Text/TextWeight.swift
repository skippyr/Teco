//
//  TextWeight.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros <skippyr.developer@icloud.com>
//  Visit my website: https://dragonscave.xyz.
//  Follow me on GitHub: https://github.com/skippyr.
//
//  Refer to the LICENSE file that comes in its source code for more details.
//  If not available, all rights are reserved to the author.
//

/// Contains the available terminal text weights.
public enum TextWeight {
    /// Makes the text use bold font and/or use bright colors.
    case bold
    /// Makes the text colors faint.
    case dim

    var ansi: UInt8 {
        switch self {
        case .bold:
            1
        case .dim:
            2
        }
    }
}
