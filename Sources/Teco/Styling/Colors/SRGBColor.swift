//
//  SRGBColor.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros <skippyr.developer@icloud.com>
//  Visit my website: https://dragonscave.xyz.
//  Follow me on GitHub: https://github.com/skippyr.
//
//  Refer to the LICENSE file that comes in its source code for more details.
//  If not available, all rights are reserved to the author.
//

/// Represents an RGB color described within the sRGB color space.
public struct SRGBColor {
    /// The red component of the color.
    let red: Component
    /// The green component of the color.
    let green: Component
    /// The blue component of the color.
    let blue: Component

    /// Creates a color from its components.
    ///
    /// - Parameter red: the red component.
    /// - Parameter green: the green component.
    /// - Parameter blue: the blue component.
    public init(red: Component, green: Component, blue: Component) {
        self.red = red
        self.green = green
        self.blue = blue
    }

    /// Represents a component of the color.
    public typealias Component = UInt8
}
