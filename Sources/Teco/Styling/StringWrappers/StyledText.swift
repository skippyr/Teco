//
//  StyledText.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros <skippyr.developer@icloud.com>
//  Visit my website: https://dragonscave.xyz.
//  Follow me on GitHub: https://github.com/skippyr.
//
//  Refer to the LICENSE file that comes in its source code for more details.
//  If not available, all rights are reserved to the author.
//

/// Glues styled fragments together in order to make a full text, possibly with mixed styles.
public struct StyledText: ExpressibleByStringInterpolation, CustomStringConvertible {
    /// The fragments being glued.
    public let fragments: [StyledTextFragment]
    /// Returns the concatenation of the text of all its fragments, applying custom padding if described.
    public var string: String { fragments.map(\.string).joined() }
    public var description: String { string }

    /// Creates a styled text from the description of an `Any` type.
    ///
    /// - Parameter item: the item whose description is to be wrapped.
    public init(_ item: Any) {
        self.init(stringLiteral: String(describing: item))
    }

    /// Creates a styled text from a fragment.
    ///
    /// - Parameter fragment: the fragment to be considered.
    public init(_ fragment: StyledTextFragment) {
        fragments = fragment.string.isEmpty ? [] : [fragment]
    }

    public init(stringLiteral: String) {
        fragments = stringLiteral.isEmpty ? [] : [.init(stringLiteral)]
    }

    public init(stringInterpolation: StringInterpolation) {
        fragments = stringInterpolation.fragments
    }

    public struct StringInterpolation: StringInterpolationProtocol {
        var fragments: [StyledTextFragment]

        public init(literalCapacity: Int, interpolationCount: Int) {
            fragments = []
            fragments.reserveCapacity(literalCapacity + interpolationCount)
        }

        public mutating func appendLiteral(_ literal: StringLiteralType) {
            if !literal.isEmpty { fragments.append(.init(literal)) }
        }

        public mutating func appendInterpolation(_ fragment: StyledTextFragment) {
            if !fragment.string.isEmpty { fragments.append(fragment) }
        }

        public mutating func appendInterpolation(_ string: StyledText) {
            fragments.append(contentsOf: string.fragments.filter { !$0.string.isEmpty })
        }

        public mutating func appendInterpolation(_ value: Any) {
            appendLiteral(String(describing: value))
        }
    }
}
