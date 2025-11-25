//
//  WritableStream.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros <skippyr.developer@icloud.com>
//  Visit my website: https://dragonscave.xyz.
//  Follow me on GitHub: https://github.com/skippyr.
//
//  Refer to the LICENSE file that comes in its source code for more details.
//  If not available, all rights are reserved to the author.
//

/// Contains the terminal streams that can be written to.
public enum WritableStream {
    /// The standard output stream (`stdout`).
    case output
    /// The standard error stream (`stderr`).
    case error
}
