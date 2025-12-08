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
