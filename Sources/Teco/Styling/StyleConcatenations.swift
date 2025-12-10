//
//  File: StyleConcatenations.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros (skippyr.developer@icloud.com)
//  Connect: https://dragonscave.xyz | GitHub: https://github.com/skippyr
//
//  Refer to the LICENSE file included with this source code for full terms.
//  See the NOTICE file, if included, for third-party attributions.
//

/// Concatenates two styled fragments together.
///
/// - Returns: a styled text containing both.
public func + (lhs: StyledTextFragment, rhs: StyledTextFragment) -> StyledText {
    "\(lhs)\(rhs)"
}

/// Concatenates two styled fragments together.
///
/// - Returns: a styled text containing both.
public func += (lhs: StyledTextFragment, rhs: StyledTextFragment) -> StyledText {
    "\(lhs)\(rhs)"
}

/// Concatenates a styled text fragment to a styled text.
///
/// - Returns: a styled text containing both.
public func + (lhs: StyledTextFragment, rhs: StyledText) -> StyledText {
    "\(lhs)\(rhs)"
}

/// Concatenates a styled text fragment to a styled text.
///
/// - Returns: a styled text containing both.
public func += (lhs: StyledTextFragment, rhs: StyledText) -> StyledText {
    "\(lhs)\(rhs)"
}

/// Concatenates a styled text fragment to a styled text.
///
/// - Returns: a styled text containing both.
public func + (lhs: StyledText, rhs: StyledTextFragment) -> StyledText {
    "\(lhs)\(rhs)"
}

/// Concatenates a styled text fragment to a styled text.
///
/// - Returns: a styled text containing both.
public func += (lhs: StyledText, rhs: StyledTextFragment) -> StyledText {
    "\(lhs)\(rhs)"
}

/// Concatenates two styled texts together.
///
/// - Returns: a styled text containing both.
public func + (lhs: StyledText, rhs: StyledText) -> StyledText {
    "\(lhs)\(rhs)"
}

/// Concatenates two styled texts together.
///
/// - Returns: a styled text containing both.
public func += (lhs: StyledText, rhs: StyledText) -> StyledText {
    "\(lhs)\(rhs)"
}
