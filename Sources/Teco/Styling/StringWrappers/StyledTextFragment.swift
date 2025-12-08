//
//  File: StyledTextFragment.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros (skippyr.developer@icloud.com)
//  Connect: https://dragonscave.xyz | GitHub: https://github.com/skippyr
//
//  Refer to the LICENSE file included with this source code for full terms.
//  See the NOTICE file, if included, for third-party attributions.
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
    /// Returns the length of the string being wrapped.
    public var count: Int { string.count }

    /// Creates a fragment from a string.
    ///
    /// - Parameter string: the string to be wrapped.
    /// - Parameter style: the style to associated with it.
    public init(_ string: String, style: TextStyle = .init()) {
        _string = string
        self.style = style
    }
}
