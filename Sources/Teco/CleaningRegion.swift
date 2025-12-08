//
//  File: CleaningRegion.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros (skippyr.developer@icloud.com)
//  Connect: https://dragonscave.xyz | GitHub: https://github.com/skippyr
//
//  Refer to the LICENSE file included with this source code for full terms.
//  See the NOTICE file, if included, for third-party attributions.
//

/// Contains the regions of the terminal that can be cleared. Each contains a corresponding restore cursor position.
public enum CleaningRegion {
    /// Clears the screen and moves the cursor to its top left corner.
    case screen
    /// Clears the line the cursor is currently on and moves it to its first column.
    case line

    var ansi: String {
        switch self {
        case .screen:
            "\u{1b}[2J\u{1b}[H"
        case .line:
            "\u{1b}[2K\u{1b}[G"
        }
    }
}
