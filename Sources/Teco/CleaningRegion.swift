//
//  CleaningRegion.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros <skippyr.developer@icloud.com>
//  Visit my website: https://dragonscave.xyz.
//  Follow me on GitHub: https://github.com/skippyr.
//
//  Refer to the LICENSE file that comes in its source code for more details.
//  If not available, all rights are reserved to the author.
//

/// Contains the regions of the terminal that can be cleared. Each contains a default cursor position, where it gets restored after cleaning.
enum CleaningRegion {
    /// Clears the screen and moves the cursor to its top left corner.
    case screen
    /// Clears the line the cursor is currently on and moves it to its first column.
    case line
    /// Clears the scrollback buffer and moves the cursor to the top left corner of the screen.
    case scrollback

    var ansi: String {
        switch self {
        case .screen:
            "\u{1b}[2J\u{1b}[H"
        case .line:
            "\u{1b}[2K\u{1b}[G"
        case .scrollback:
            "\u{1b}[3J\u{1b}[H"
        }
    }
}
