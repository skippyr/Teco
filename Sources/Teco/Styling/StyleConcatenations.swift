//
//  StyleConcatenations.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros <skippyr.developer@icloud.com>
//  Visit my website: https://dragonscave.xyz.
//  Follow me on GitHub: https://github.com/skippyr.
//
//  Refer to the LICENSE file that comes in its source code for more details.
//  If not available, all rights are reserved to the author.
//

public func + (lhs: StyledTextFragment, rhs: StyledTextFragment) -> StyledText {
    "\(lhs)\(rhs)"
}

public func += (lhs: StyledTextFragment, rhs: StyledTextFragment) -> StyledText {
    "\(lhs)\(rhs)"
}

public func + (lhs: StyledTextFragment, rhs: StyledText) -> StyledText {
    "\(lhs)\(rhs)"
}

public func += (lhs: StyledTextFragment, rhs: StyledText) -> StyledText {
    "\(lhs)\(rhs)"
}

public func + (lhs: StyledText, rhs: StyledTextFragment) -> StyledText {
    "\(lhs)\(rhs)"
}

public func += (lhs: StyledText, rhs: StyledTextFragment) -> StyledText {
    "\(lhs)\(rhs)"
}

public func + (lhs: StyledText, rhs: StyledText) -> StyledText {
    "\(lhs)\(rhs)"
}

public func += (lhs: StyledText, rhs: StyledText) -> StyledText {
    "\(lhs)\(rhs)"
}
