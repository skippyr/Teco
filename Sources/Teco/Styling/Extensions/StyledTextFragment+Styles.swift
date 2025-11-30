//
//  StyledTextFragment+Styles.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros <skippyr.developer@icloud.com>
//  Visit my website: https://dragonscave.xyz.
//  Follow me on GitHub: https://github.com/skippyr.
//
//  Refer to the LICENSE file that comes in its source code for more details.
//  If not available, all rights are reserved to the author.
//

extension StyledTextFragment {
    fileprivate func appendingStyle(foreground: Color? = nil, background: Color? = nil, weight: TextWeight? = nil, effects: Set<TextEffect>? = nil, padding: TextPadding? = nil) -> StyledTextFragment {
        var style = style
        if let foreground {
            style.foreground = foreground
        }
        if let background {
            style.background = background
        }
        if let weight {
            style.weight = weight
        }
        if let effects {
            var newEffects = style.effects ?? []
            newEffects.formUnion(effects)
            style.effects = newEffects
        }
        if let padding {
            style.padding = padding
        }
        return .init(string, style: style)
    }

    /// Returns a copy of the current fragment setting ANSI black as the foreground color.
    ///
    /// This color usually matches the terminal background. In light themes, it may be replaced by a near-white shade instead of black.
    public var black: StyledTextFragment { appendingStyle(foreground: .black) }
    /// Returns a copy of the current fragment setting ANSI red as the foreground color.
    public var red: StyledTextFragment { appendingStyle(foreground: .red) }
    /// Returns a copy of the current fragment setting ANSI green as the foreground color.
    public var green: StyledTextFragment { appendingStyle(foreground: .green) }
    /// Returns a copy of the current fragment setting ANSI yellow as the foreground color.
    public var yellow: StyledTextFragment { appendingStyle(foreground: .yellow) }
    /// Returns a copy of the current fragment setting ANSI blue as the foreground color.
    public var blue: StyledTextFragment { appendingStyle(foreground: .blue) }
    /// Returns a copy of the current fragment setting ANSI magenta as the foreground color.
    public var magenta: StyledTextFragment { appendingStyle(foreground: .magenta) }
    /// Returns a copy of the current fragment setting ANSI cyan as the foreground color.
    public var cyan: StyledTextFragment { appendingStyle(foreground: .cyan) }
    /// Returns a copy of the current fragment setting ANSI bright white as the foreground color.
    ///
    /// This color usually matches the terminal foreground. In light themes, it may be replaced by a near-black shade instead of white.
    public var white: StyledTextFragment { appendingStyle(foreground: .white) }
    /// Returns a copy of the current fragment setting ANSI bright black as the foreground color.
    ///
    /// This color is usually a darker shade of the terminal foreground, useful for captions.
    public var gray: StyledTextFragment { appendingStyle(foreground: .gray) }

    /// Returns a copy of the current fragment setting the ANSI color provided as the foreground color.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the modified copy.
    public func ansi(_ color: ANSIColor) -> StyledTextFragment {
        appendingStyle(foreground: .ansi(color))
    }

    @available(*, deprecated, renamed: "sRGB")
    public func srgb(_ color: SRGBColor) -> StyledTextFragment {
        sRGB(color)
    }

    /// Returns a copy of the current fragment setting the sRGB color provided as the foreground color.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the modified copy.
    public func sRGB(_ color: SRGBColor) -> StyledTextFragment {
        appendingStyle(foreground: .sRGB(color))
    }

    @available(*, deprecated, renamed: "sRGB")
    public func srgb(red: SRGBColor.Component, green: SRGBColor.Component, blue: SRGBColor.Component) -> StyledTextFragment {
        sRGB(red: red, green: green, blue: blue)
    }

    /// Returns a copy of the current fragment setting the sRGB color created from the components provided as the foreground color.
    ///
    /// - Parameter red: the red component of the color.
    /// - Parameter green: the green component of the color.
    /// - Parameter blue: the blue component of the color.
    /// - Returns: the modified copy.
    public func sRGB(red: SRGBColor.Component, green: SRGBColor.Component, blue: SRGBColor.Component) -> StyledTextFragment {
        appendingStyle(foreground: .sRGB(.init(red: red, green: green, blue: blue)))
    }

    /// Returns a copy of the current fragment setting ANSI red as the background color.
    public var onRed: StyledTextFragment { appendingStyle(background: .red) }
    /// Returns a copy of the current fragment setting ANSI green as the background color.
    public var onGreen: StyledTextFragment { appendingStyle(background: .green) }
    /// Returns a copy of the current fragment setting ANSI yellow as the background color.
    public var onYellow: StyledTextFragment { appendingStyle(background: .yellow) }
    /// Returns a copy of the current fragment setting ANSI blue as the background color.
    public var onBlue: StyledTextFragment { appendingStyle(background: .blue) }
    /// Returns a copy of the current fragment setting ANSI magenta as the background color.
    public var onMagenta: StyledTextFragment { appendingStyle(background: .magenta) }
    /// Returns a copy of the current fragment setting ANSI cyan as the background color.
    public var onCyan: StyledTextFragment { appendingStyle(background: .cyan) }
    /// Returns a copy of the current fragment setting ANSI bright white as the background color.
    ///
    /// This color usually matches the terminal foreground. In light themes, it may be replaced by a near-black shade instead of white.
    ///
    /// If you're planning to invert the colors of a text, prefer to use the inverted layers effect.
    public var onWhite: StyledTextFragment { appendingStyle(background: .white) }
    /// Returns a copy of the current fragment setting ANSI bright black as the background color.
    public var onGray: StyledTextFragment { appendingStyle(background: .gray) }

    /// Returns a copy of the current fragment setting the ANSI color provided as the background color.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the modified copy.
    public func onANSI(_ color: ANSIColor) -> StyledTextFragment {
        appendingStyle(background: .ansi(color))
    }

    /// Returns a copy of the current fragment setting the sRGB color provided as the background color.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the modified copy.
    public func onSRGB(_ color: SRGBColor) -> StyledTextFragment {
        appendingStyle(background: .sRGB(color))
    }

    /// Returns a copy of the current fragment setting the sRGB color created from the components provided as the background color.
    ///
    /// - Parameter red: the red component of the color.
    /// - Parameter green: the green component of the color.
    /// - Parameter blue: the blue component of the color.
    /// - Returns: the modified copy.
    public func onSRGB(red: SRGBColor.Component, green: SRGBColor.Component, blue: SRGBColor.Component) -> StyledTextFragment {
        appendingStyle(background: .sRGB(.init(red: red, green: green, blue: blue)))
    }

    /// Returns a copy of the current fragment setting a color in a text layer.
    ///
    /// - Parameter color: the color to be applied.
    /// - Parameter layer: the layer to be affected.
    /// - Returns: the modified copy.
    public func color(_ color: Color, at layer: TextLayer) -> StyledTextFragment {
        switch layer {
        case .foreground:
            appendingStyle(foreground: color)
        case .background:
            appendingStyle(background: color)
        }
    }

    /// Returns a copy of the current fragment setting bold as the text weight.
    public var bold: StyledTextFragment { appendingStyle(weight: .bold) }
    /// Returns a copy of the current fragment setting dim as the text weight.
    public var dim: StyledTextFragment { appendingStyle(weight: .dim) }

    /// Returns a copy of the current fragment setting the text weight provided.
    ///
    /// - Parameter weight: the weight to be applied.
    /// - Returns: the modified copy.
    public func weight(_ weight: TextWeight) -> StyledTextFragment {
        appendingStyle(weight: weight)
    }

    /// Returns a copy of the current fragment setting italic as an active effect.
    public var italic: StyledTextFragment { appendingStyle(effects: [.italic]) }
    /// Returns a copy of the current fragment setting underline as an active effect.
    public var underline: StyledTextFragment { appendingStyle(effects: [.underline]) }
    @available(*, deprecated, renamed: "blink")
    public var blinking: StyledTextFragment { blink }
    /// Returns a copy of the current fragment setting blink as an active effect.
    public var blink: StyledTextFragment { appendingStyle(effects: [.blink]) }
    @available(*, deprecated, renamed: "swapLayers")
    public var invertedLayers: StyledTextFragment { swapLayers }
    /// Returns a copy of the current fragment setting swap layers as an active effect.
    public var swapLayers: StyledTextFragment { appendingStyle(effects: [.swapLayers]) }
    /// Returns a copy of the current fragment setting strikethrough as an active effect.
    public var strikethrough: StyledTextFragment { appendingStyle(effects: [.strikethrough]) }

    /// Returns a copy of the current fragment setting the effects provided as active.
    ///
    /// - Parameter effects: the effects to be activated.
    /// - Returns: the modified copy.
    @available(*, deprecated, message: "Use the overload that accepts a Set<TextEffect> or specific effect methods.")
    public func effects(_ effects: TextEffect...) -> StyledTextFragment {
        appendingStyle(effects: Set(effects))
    }

    /// Returns a copy of the current fragment setting the effects provided as active.
    ///
    /// - Parameter effects: the effects to be activated.
    /// - Returns: the modified copy.
    public func effects(_ effects: Set<TextEffect>) -> StyledTextFragment {
        appendingStyle(effects: effects)
    }

    /// Returns a copy of the current fragment setting the padding provided.
    ///
    /// - Parameter padding: the padding to be applied.
    /// - Returns: the modified copy.
    public func pad(using padding: TextPadding) -> StyledTextFragment {
        appendingStyle(padding: padding)
    }

    /// Returns a copy of the current fragment setting the padding created from the components provided.
    ///
    /// - Parameter alignment: the alignment for the text being padded.
    /// - Parameter character: the character to pad with.
    /// - Parameter length: the length for the padding, including the text area.
    /// - Returns: the modified copy.
    public func pad(_ alignment: TextAlignment, with character: Character = " ", by length: Terminal.Size) -> StyledTextFragment {
        appendingStyle(padding: .init(alignment, with: character, by: length))
    }

    /// Returns a copy of the current fragment setting the style provided.
    ///
    /// - Parameter style: the style to be applied.
    /// - Returns: the modified copy.
    public func style(_ style: TextStyle) -> StyledTextFragment {
        .init(string, style: style)
    }
}
