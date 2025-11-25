//
//  StyledTextFragment.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros <skippyr.developer@icloud.com>
//  Visit my website: https://dragonscave.xyz.
//  Follow me on GitHub: https://github.com/skippyr.
//
//  Refer to the LICENSE file that comes in its source code for more details.
//  If not available, all rights are reserved to the author.
//

/// Associates a string with a text style.
public struct StyledTextFragment: CustomStringConvertible {
    /// The string being wrapped.
    private var _string: String
    /// The style applied to the string.
    public var style: TextStyle
    /// Retrieves and sets the string being wrapped.
    ///
    /// If it describes custom padding, the string returned will have it applied.
    public var string: String {
        get {
            if let padding = style.padding {
                _string.rawPad(using: padding)
            } else {
                _string
            }
        }
        set { _string = newValue }
    }
    public var description: String { string }

    /// Creates a fragment from a string.
    ///
    /// - Parameter string: the string to be wrapped.
    /// - Parameter style: the style to associated with it.
    public init(_ string: String, style: TextStyle = .init()) {
        _string = string
        self.style = style
    }
}
