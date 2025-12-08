//
//  File: TextPadding.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros (skippyr.developer@icloud.com)
//  Connect: https://dragonscave.xyz | GitHub: https://github.com/skippyr
//
//  Refer to the LICENSE file included with this source code for full terms.
//  See the NOTICE file, if included, for third-party attributions.
//

/// Contains the information required to perform text padding within the terminal.
public struct TextPadding {
    /// The character to pad with.
    public var character: Character
    /// The length for the padding, including the text area.
    public var length: CellUnit
    /// The alignment for the text being padded.
    public var alignment: TextAlignment

    @available(*, deprecated, renamed: "init(align:with:upTo:)")
    public init(_ alignment: TextAlignment, with character: Character = " ", by length: CellUnit) {
        self.alignment = alignment
        self.character = character
        self.length = length
    }

    /// Creates new information about padding from its component.
    ///
    /// - Parameter alignment: the alignment for the text being padded.
    /// - Parameter character: the character to pad with.
    /// - Parameter length: the length for the padding, including the text area.
    public init(align alignment: TextAlignment, with character: Character = " ", upTo length: CellUnit) {
        self.alignment = alignment
        self.character = character
        self.length = length
    }
}
