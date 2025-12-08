//
//  File: Color.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros (skippyr.developer@icloud.com)
//  Connect: https://dragonscave.xyz | GitHub: https://github.com/skippyr
//
//  Refer to the LICENSE file included with this source code for full terms.
//  See the NOTICE file, if included, for third-party attributions.
//

/// Contains color formats and pre-defined ANSI colors the terminal can apply.
public enum Color {
    /// The ANSI black color, equivalent to `.ansi(0)`.
    ///
    /// This color usually matches the background. In light themes, it may be replaced by a near-white shade instead of black.
    public static var black: Color { .ansi(0) }
    /// The ANSI red color, equivalent to `.ansi(1)`.
    public static var red: Color { .ansi(1) }
    /// The ANSI green color, equivalent to `.ansi(2)`.
    public static var green: Color { .ansi(2) }
    /// The ANSI yellow color, equivalent to `.ansi(3)`.
    public static var yellow: Color { .ansi(3) }
    /// The ANSI blue color, equivalent to `.ansi(4)`.
    public static var blue: Color { .ansi(4) }
    /// The ANSI magenta color, equivalent to `.ansi(5)`.
    public static var magenta: Color { .ansi(5) }
    /// The ANSI cyan color, equivalent to `.ansi(6)`.
    public static var cyan: Color { .ansi(6) }
    /// The ANSI bright white color, equivalent to `.ansi(15)`.
    ///
    /// This color usually matches the foreground. In light themes, it may be replaced by a near-black shade instead of white.
    public static var white: Color { .ansi(15) }
    /// The ANSI bright black color, equivalent to `.ansi(8)`.
    ///
    /// This color is usually a darker shade of the foreground, useful for captions.
    public static var gray: Color { .ansi(8) }

    /// A color of the ANSI 256-color palette.
    ///
    /// The first 16 colors of this palette should match the ones defined by the terminal theme. Alternatively, you can refer to some of them by name using static values of this enum.
    ///
    /// - Parameter color: the value of the color.
    case ansi(ANSIColor)
    @available(*, deprecated, renamed: "sRGB")
    case srgb(SRGBColor)
    /// An RGB color described within the sRGB color space.
    ///
    /// - Parameter color: the color.
    case sRGB(SRGBColor)
}
