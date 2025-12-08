//
//  File: WritableStream.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros (skippyr.developer@icloud.com)
//  Connect: https://dragonscave.xyz | GitHub: https://github.com/skippyr
//
//  Refer to the LICENSE file included with this source code for full terms.
//  See the NOTICE file, if included, for third-party attributions.
//

/// Contains the terminal streams that can be written to.
public enum WritableStream {
    /// The standard output stream (`stdout`). Used for general output and TUI, it's line-buffered.
    case output
    /// The standard error stream (`stderr`). Used for the output of messages, it's unbuffered.
    case error
}
