//
//  StyledConcatenations.swift
//  Teco
//
//  Created by Sherman Barros on 11/17/25.
//

public func + (lhs: Terminal.StyledFragment, rhs: Terminal.StyledFragment) -> Terminal.StyledString {
    "\(lhs)\(rhs)"
}

public func + (lhs: Terminal.StyledFragment, rhs: Terminal.StyledString) -> Terminal.StyledString {
    "\(lhs)\(rhs)"
}

public func + (lhs: Terminal.StyledString, rhs: Terminal.StyledFragment) -> Terminal.StyledString {
    "\(lhs)\(rhs)"
}

public func + (lhs: Terminal.StyledString, rhs: Terminal.StyledString) -> Terminal.StyledString {
    "\(lhs)\(rhs)"
}
