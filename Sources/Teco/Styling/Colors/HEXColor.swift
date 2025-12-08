//
//  File: HEXColor.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros (skippyr.developer@icloud.com)
//  Connect: https://dragonscave.xyz | GitHub: https://github.com/skippyr
//
//  Refer to the LICENSE file included with this source code for full terms.
//  See the NOTICE file, if included, for third-party attributions.
//

/// The type that can hold all possible values for a HEX color.
public typealias HEXColor = UInt32

extension HEXColor {
    /// The maximum value for a HEX color without alpha channel.
    public var maxHEX: HEXColor {
        0xFFFFFF
    }
}
