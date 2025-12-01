//
//  CursorShape.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros <skippyr.developer@icloud.com>
//  Visit my website: https://dragonscave.xyz.
//  Follow me on GitHub: https://github.com/skippyr.
//
//  Refer to the LICENSE file that comes in its source code for more details.
//  If not available, all rights are reserved to the author.
//

/// Contains the available terminal cursor shapes.
enum CursorShape {
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
