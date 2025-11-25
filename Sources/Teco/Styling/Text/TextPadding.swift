//
//  TextPadding.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros <skippyr.developer@icloud.com>
//  Visit my website: https://dragonscave.xyz.
//  Follow me on GitHub: https://github.com/skippyr.
//
//  Refer to the LICENSE file that comes in its source code for more details.
//  If not available, all rights are reserved to the author.
//

/// Contains the information required to perform text padding within the terminal.
public struct TextPadding {
    /// The character to pad with.
    public var character: Character
    /// The length for the padding, including the text area.
    public var length: Terminal.Size
    /// The alignment for the text being padded.
    public var alignment: TextAlignment

    /// Creates new information about padding from its component.
    ///
    /// - Parameter alignment: the alignment for the text being padded.
    /// - Parameter character: the character to pad with.
    /// - Parameter length: the length for the padding, including the text area.
    public init(_ alignment: TextAlignment, with character: Character = " ", by length: Terminal.Size) {
        self.alignment = alignment
        self.character = character
        self.length = length
    }
}
