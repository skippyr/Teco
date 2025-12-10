//
//  File: SRGBColor.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros (skippyr.developer@icloud.com)
//  Connect: https://dragonscave.xyz | GitHub: https://github.com/skippyr
//
//  Refer to the LICENSE file included with this source code for full terms.
//  See the NOTICE file, if included, for third-party attributions.
//

import AppKit

/// Represents an RGB color described within the sRGB color space.
public struct SRGBColor {
    /// The red component of the color.
    public let red: Component
    /// The green component of the color.
    public let green: Component
    /// The blue component of the color.
    public let blue: Component

    /// Returns the color representation in HEX format, uppercased, zero-padded to 6 characters, and without a prefix symbol (eg.: `FF0000`).
    public var hexDescription: String {
        String(format: "%06X", HEXColor(red) << 16 | HEXColor(green) << 8 | HEXColor(blue))
    }

    /// Creates an sRGB color from its components.
    ///
    /// - Parameter red: the red component.
    /// - Parameter green: the green component.
    /// - Parameter blue: the blue component.
    public init(red: Component, green: Component, blue: Component) {
        self.red = red
        self.green = green
        self.blue = blue
    }

    /// Creates an sRGB color from a HEX color number.
    ///
    /// - Parameter hex: the color to be considered.
    /// - Returns: the sRGB color or `nil` if the HEX color is greater than `0xFFFFFF`.
    public init?(hex: HEXColor) {
        guard hex < hex.maxHEX else {
            return nil
        }
        red = Component(hex >> 16 & 0xFF)
        green = Component(hex >> 8 & 0xFF)
        blue = Component(hex & 0xFF)
    }

    private static func convertNSColorComponent(_ component: CGFloat) -> Component {
        let partial = component * 255
        guard partial >= 0 && partial <= CGFloat(Component.max) else {
            return if partial < 0 {
                0
            } else {
                Component.max
            }
        }
        return Component(partial)
    }

    /// Creates an sRGB color from the components of an `NSColor`. The alpha channel is ignored.
    ///
    /// This initializer exists to give support for the `#colorLiteral` macro.
    ///
    /// - Parameter color: the color to be considered.
    /// - Returns: the sRGB color or `nil` if the `NSColor` instance cannot be represented within the sRGB color space.
    public init?(_ color: NSColor) {
        guard let color = color.usingColorSpace(.sRGB) else {
            return nil
        }
        red = SRGBColor.convertNSColorComponent(color.redComponent)
        green = SRGBColor.convertNSColorComponent(color.greenComponent)
        blue = SRGBColor.convertNSColorComponent(color.blueComponent)
    }

    /// Represents a component of the color.
    public typealias Component = UInt8
}
