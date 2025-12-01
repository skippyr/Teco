//
//  HEXColor.swift
//  Teco
//
//  Created by Sherman Rofeman on 2/12/25.
//

/// The type that can hold all possible values for a HEX color.
public typealias HEXColor = UInt32

extension HEXColor {
    /// The maximum value for a HEX color without alpha channel.
    public var maxHEX: HEXColor {
        0xFFFFFF
    }
}
