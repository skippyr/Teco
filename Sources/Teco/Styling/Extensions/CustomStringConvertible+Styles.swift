//
//  CustomStringConvertible+Styles.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros <skippyr.developer@icloud.com>
//  Visit my website: https://dragonscave.xyz.
//  Follow me on GitHub: https://github.com/skippyr.
//
//  Refer to the LICENSE file that comes in its source code for more details.
//  If not available, all rights are reserved to the author.
//

extension CustomStringConvertible {
    /// Creates a styled text fragment from the description of the current instance, setting ANSI black as the foreground color.
    ///
    /// This color usually matches the terminal background. In light themes, it may be replaced by a near-white shade instead of black.
    public var black: StyledTextFragment { .init(description, style: .init(foreground: .black)) }
    /// Creates a styled text fragment from the description of the current instance, setting ANSI red as the foreground color.
    public var red: StyledTextFragment { .init(description, style: .init(foreground: .red)) }
    /// Creates a styled text fragment from the description of the current instance, setting ANSI green as the foreground color.
    public var green: StyledTextFragment { .init(description, style: .init(foreground: .green)) }
    /// Creates a styled text fragment from the description of the current instance, setting ANSI yellow as the foreground color.
    public var yellow: StyledTextFragment { .init(description, style: .init(foreground: .yellow)) }
    /// Creates a styled text fragment from the description of the current instance, setting ANSI blue as the foreground color.
    public var blue: StyledTextFragment { .init(description, style: .init(foreground: .blue)) }
    /// Creates a styled text fragment from the description of the current instance, setting ANSI magenta as the foreground color.
    public var magenta: StyledTextFragment { .init(description, style: .init(foreground: .magenta)) }
    /// Creates a styled text fragment from the description of the current instance, setting ANSI cyan as the foreground color.
    public var cyan: StyledTextFragment { .init(description, style: .init(foreground: .cyan)) }
    /// Creates a styled text fragment from the description of the current instance, setting ANSI bright white as the foreground color.
    ///
    /// This color usually matches the terminal foreground. In light themes, it may be replaced by a near-black shade instead of white.
    public var white: StyledTextFragment { .init(description, style: .init(foreground: .white)) }
    /// Creates a styled text fragment from the description of the current instance, setting ANSI bright black as the foreground color.
    ///
    /// This color is usually a darker shade of the terminal foreground, useful for captions.
    public var gray: StyledTextFragment { .init(description, style: .init(foreground: .gray)) }

    /// Creates a styled text fragment from the description of the current instance, setting the ANSI color provided as the foreground color.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the fragment.
    public func ansi(_ color: ANSIColor) -> StyledTextFragment {
        .init(description, style: .init(foreground: .ansi(color)))
    }

    @available(*, deprecated, renamed: "sRGB")
    public func srgb(_ color: SRGBColor) -> StyledTextFragment {
        sRGB(color)
    }

    /// Creates a styled text fragment from the description of the current instance, setting the sRGB color provided as the foreground color.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the fragment.
    public func sRGB(_ color: SRGBColor) -> StyledTextFragment {
        .init(description, style: .init(foreground: .sRGB(color)))
    }

    @available(*, deprecated, renamed: "sRGB")
    public func srgb(red: SRGBColor.Component, green: SRGBColor.Component, blue: SRGBColor.Component) -> StyledTextFragment {
        sRGB(red: red, green: green, blue: blue)
    }

    /// Creates a styled text fragment from the description of the current instance, setting the sRGB color created from the components provided as the foreground color.
    ///
    /// - Parameter red: the red component of the color.
    /// - Parameter green: the green component of the color.
    /// - Parameter blue: the blue component of the color.
    /// - Returns: the fragment.
    public func sRGB(red: SRGBColor.Component, green: SRGBColor.Component, blue: SRGBColor.Component) -> StyledTextFragment {
        .init(description, style: .init(foreground: .sRGB(.init(red: red, green: green, blue: blue))))
    }

    /// Creates a styled text fragment from the description of the current instance, setting ANSI red as the background color.
    public var onRed: StyledTextFragment { .init(description, style: .init(background: .red)) }
    /// Creates a styled text fragment from the description of the current instance, setting ANSI green as the background color.
    public var onGreen: StyledTextFragment { .init(description, style: .init(background: .green)) }
    /// Creates a styled text fragment from the description of the current instance, setting ANSI yellow as the background color.
    public var onYellow: StyledTextFragment { .init(description, style: .init(background: .yellow)) }
    /// Creates a styled text fragment from the description of the current instance, setting ANSI blue as the background color.
    public var onBlue: StyledTextFragment { .init(description, style: .init(background: .blue)) }
    /// Creates a styled text fragment from the description of the current instance, setting ANSI magenta as the background color.
    public var onMagenta: StyledTextFragment { .init(description, style: .init(background: .magenta)) }
    /// Creates a styled text fragment from the description of the current instance, setting ANSI cyan as the background color.
    public var onCyan: StyledTextFragment { .init(description, style: .init(background: .cyan)) }
    /// Creates a styled text fragment from the description of the current instance, setting ANSI bright white as the background color.
    ///
    /// This color usually matches the terminal foreground. In light themes, it may be replaced by a near-black shade instead of white.
    ///
    /// If you're planning to invert the colors of a text, prefer to use the inverted layers effect.
    public var onWhite: StyledTextFragment { .init(description, style: .init(background: .white)) }
    /// Creates a styled text fragment from the description of the current instance, setting ANSI bright black as the background color.
    public var onGray: StyledTextFragment { .init(description, style: .init(background: .gray)) }

    /// Creates a styled text fragment from the description of the current instance, setting the ANSI color provided as the background color.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the fragment.
    public func onANSI(_ color: ANSIColor) -> StyledTextFragment {
        .init(description, style: .init(background: .ansi(color)))
    }

    /// Creates a styled text fragment from the description of the current instance, setting the sRGB color provided as the background color.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the fragment.
    public func onSRGB(_ color: SRGBColor) -> StyledTextFragment {
        .init(description, style: .init(background: .sRGB(color)))
    }

    /// Creates a styled text fragment from the description of the current instance, setting the sRGB color created from the components provided as the background color.
    ///
    /// - Parameter red: the red component of the color.
    /// - Parameter green: the green component of the color.
    /// - Parameter blue: the blue component of the color.
    /// - Returns: the fragment.
    public func onSRGB(red: SRGBColor.Component, green: SRGBColor.Component, blue: SRGBColor.Component) -> StyledTextFragment {
        .init(description, style: .init(background: .sRGB(.init(red: red, green: green, blue: blue))))
    }

    /// Creates a styled text fragment from the description of the current instance, setting a color in a text layer.
    ///
    /// - Parameter color: the color to be applied.
    /// - Parameter layer: the layer to be affected.
    /// - Returns: the fragment.
    public func color(_ color: Color, at layer: TextLayer) -> StyledTextFragment {
        var style = TextStyle()
        switch layer {
        case .foreground:
            style.foreground = color
        case .background:
            style.background = color
        }
        return .init(description, style: style)
    }

    /// Creates a styled text fragment from the description of the current instance, setting bold as the text weight.
    public var bold: StyledTextFragment { .init(description, style: .init(weight: .bold)) }
    /// Creates a styled text fragment from the description of the current instance, setting dim as the text weight.
    public var dim: StyledTextFragment { .init(description, style: .init(weight: .dim)) }

    /// Creates a styled text fragment from the description of the current instance, setting the text weight provided.
    ///
    /// - Parameter weight: the weight to be applied.
    /// - Returns: the fragment.
    public func weight(_ weight: TextWeight) -> StyledTextFragment {
        .init(description, style: .init(weight: weight))
    }

    /// Creates a styled text fragment from the description of the current instance, setting italic as an active effect.
    public var italic: StyledTextFragment { .init(description, style: .init(effects: [.italic])) }
    /// Creates a styled text fragment from the description of the current instance, setting underline as an active effect.
    public var underline: StyledTextFragment { .init(description, style: .init(effects: [.underline])) }
    @available(*, deprecated, renamed: "blink")
    public var blinking: StyledTextFragment { blink }
    /// Creates a styled text fragment from the description of the current instance, setting blink as an active effect.
    public var blink: StyledTextFragment { .init(description, style: .init(effects: [.blink])) }
    @available(*, deprecated, renamed: "swapLayers")
    public var invertedLayers: StyledTextFragment { swapLayers }
    /// Creates a styled text fragment from the description of the current instance, setting swap layers as an active effect.
    public var swapLayers: StyledTextFragment { .init(description, style: .init(effects: [.swapLayers])) }
    /// Creates a styled text fragment from the description of the current instance, setting strikethrough as an active effect.
    public var strikethrough: StyledTextFragment { .init(description, style: .init(effects: [.strikethrough])) }

    @available(*, deprecated, message: "Use the overload that accepts a Set<TextEffect> or specific effect methods.")
    public func effects(_ effects: TextEffect...) -> StyledTextFragment {
        .init(description, style: .init(effects: Set(effects)))
    }

    /// Creates a styled text fragment from the description of the current instance, setting the effects provided as active.
    ///
    /// - Parameter effects: the effects to be activated.
    /// - Returns: the fragment.
    public func effects(_ effects: Set<TextEffect>) -> StyledTextFragment {
        .init(description, style: .init(effects: effects))
    }

    /// Creates a styled text fragment from the description of the current instance, setting the padding provided.
    ///
    /// - Parameter padding: the padding to be applied.
    /// - Returns: the fragment.
    public func pad(using padding: TextPadding) -> StyledTextFragment {
        .init(description, style: .init(padding: padding))
    }

    /// Creates a styled text fragment from the description of the current instance, setting the padding created from the components provided.
    ///
    /// - Parameter alignment: the alignment for the text being padded.
    /// - Parameter character: the character to pad with.
    /// - Parameter length: the length for the padding, including the text area.
    /// - Returns: the fragment.
    public func pad(_ alignment: TextAlignment, with character: Character = " ", by length: CellUnit) -> StyledTextFragment {
        .init(description, style: .init(padding: .init(alignment, with: character, by: length)))
    }

    /// Creates a styled text fragment from the description of the current instance, setting the style provided.
    ///
    /// - Parameter style: the style to be applied.
    /// - Returns: the fragment.
    public func style(_ style: TextStyle) -> StyledTextFragment {
        .init(description, style: style)
    }
}
