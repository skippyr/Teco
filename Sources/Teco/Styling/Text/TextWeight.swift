//
//  File: TextWeight.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros (skippyr.developer@icloud.com)
//  Connect: https://dragonscave.xyz | GitHub: https://github.com/skippyr
//
//  Refer to the LICENSE file included with this source code for full terms.
//  See the NOTICE file, if included, for third-party attributions.
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
