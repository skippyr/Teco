//
//  File: CursorShape.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros (skippyr.developer@icloud.com)
//  Connect: https://dragonscave.xyz | GitHub: https://github.com/skippyr
//
//  Refer to the LICENSE file included with this source code for full terms.
//  See the NOTICE file, if included, for third-party attributions.
//

/// Contains the available terminal cursor shapes.
public enum CursorShape {
    /// Fills the whole cursor cell.
    case block
    /// Fills the bottom of the cursor cell.
    case underline
    /// Fills the left side of the cursor cell.
    case verticalBar

    func ansi(blink: Bool) -> UInt8 {
        switch self {
        case .block:
            blink ? 1 : 2
        case .underline:
            blink ? 3 : 4
        case .verticalBar:
            blink ? 5 : 6
        }
    }
}
