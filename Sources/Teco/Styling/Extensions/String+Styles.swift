//
//  String+Styles.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros <skippyr.developer@icloud.com>
//  Visit my website: https://dragonscave.xyz.
//  Follow me on GitHub: https://github.com/skippyr.
//
//  Refer to the LICENSE file that comes in its source code for more details.
//  If not available, all rights are reserved to the author.
//

extension String {
    func rawPad(using padding: TextPadding) -> String {
        let count = max(0, Int(padding.length) - count)
        switch padding.alignment {
        case .left:
            return self + String(repeating: padding.character, count: count)
        case .right:
            return String(repeating: padding.character, count: count) + self
        case .center:
            let leftCount = count / 2
            let rightCount = count - leftCount
            return String(repeating: padding.character, count: leftCount) + self + String(repeating: padding.character, count: rightCount)
        }
    }

    /// Creates a styled text fragment from the current string setting ANSI black as the foreground color.
    ///
    /// This color usually matches the terminal background. In light themes, it may be replaced by a near-white shade instead of black.
    public var black: StyledTextFragment { .init(self, style: .init(foreground: .black)) }
    /// Creates a styled text fragment from the current string setting ANSI red as the foreground color.
    public var red: StyledTextFragment { .init(self, style: .init(foreground: .red)) }
    /// Creates a styled text fragment from the current string setting ANSI green as the foreground color.
    public var green: StyledTextFragment { .init(self, style: .init(foreground: .green)) }
    /// Creates a styled text fragment from the current string setting ANSI yellow as the foreground color.
    public var yellow: StyledTextFragment { .init(self, style: .init(foreground: .yellow)) }
    /// Creates a styled text fragment from the current string setting ANSI blue as the foreground color.
    public var blue: StyledTextFragment { .init(self, style: .init(foreground: .blue)) }
    /// Creates a styled text fragment from the current string setting ANSI magenta as the foreground color.
    public var magenta: StyledTextFragment { .init(self, style: .init(foreground: .magenta)) }
    /// Creates a styled text fragment from the current string setting ANSI cyan as the foreground color.
    public var cyan: StyledTextFragment { .init(self, style: .init(foreground: .cyan)) }
    /// Creates a styled text fragment from the current string setting ANSI bright white as the foreground color.
    ///
    /// This color usually matches the terminal foreground. In light themes, it may be replaced by a near-black shade instead of white.
    public var white: StyledTextFragment { .init(self, style: .init(foreground: .white)) }
    /// Creates a styled text fragment from the current string setting ANSI bright black as the foreground color.
    ///
    /// This color is usually a darker shade of the terminal foreground, useful for captions.
    public var gray: StyledTextFragment { .init(self, style: .init(foreground: .gray)) }

    /// Creates a styled text fragment from the current string setting the ANSI color provided as the foreground color.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the fragment.
    public func ansi(_ color: ANSIColor) -> StyledTextFragment {
        .init(self, style: .init(foreground: .ansi(color)))
    }

    /// Creates a styled text fragment from the current string setting the sRGB color provided as the foreground color.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the fragment.
    public func srgb(_ color: SRGBColor) -> StyledTextFragment {
        .init(self, style: .init(foreground: .srgb(color)))
    }

    /// Creates a styled text fragment from the current string setting the sRGB color created from the components provided as the foreground color.
    ///
    /// - Parameter red: the red component of the color.
    /// - Parameter green: the green component of the color.
    /// - Parameter blue: the blue component of the color.
    /// - Returns: the fragment.
    public func srgb(red: SRGBColor.Component, green: SRGBColor.Component, blue: SRGBColor.Component) -> StyledTextFragment {
        .init(self, style: .init(foreground: .srgb(.init(red: red, green: green, blue: blue))))
    }

    /// Creates a styled text fragment from the current string setting ANSI red as the background color.
    public var onRed: StyledTextFragment { .init(self, style: .init(background: .red)) }
    /// Creates a styled text fragment from the current string setting ANSI green as the background color.
    public var onGreen: StyledTextFragment { .init(self, style: .init(background: .green)) }
    /// Creates a styled text fragment from the current string setting ANSI yellow as the background color.
    public var onYellow: StyledTextFragment { .init(self, style: .init(background: .yellow)) }
    /// Creates a styled text fragment from the current string setting ANSI blue as the background color.
    public var onBlue: StyledTextFragment { .init(self, style: .init(background: .blue)) }
    /// Creates a styled text fragment from the current string setting ANSI magenta as the background color.
    public var onMagenta: StyledTextFragment { .init(self, style: .init(background: .magenta)) }
    /// Creates a styled text fragment from the current string setting ANSI cyan as the background color.
    public var onCyan: StyledTextFragment { .init(self, style: .init(background: .cyan)) }
    /// Creates a styled text fragment from the current string setting ANSI bright white as the background color.
    ///
    /// This color usually matches the terminal foreground. In light themes, it may be replaced by a near-black shade instead of white.
    ///
    /// If you're planning to invert the colors of a text, prefer to use the inverted layers effect.
    public var onWhite: StyledTextFragment { .init(self, style: .init(background: .white)) }
    /// Creates a styled text fragment from the current string setting ANSI bright black as the background color.
    public var onGray: StyledTextFragment { .init(self, style: .init(background: .gray)) }

    /// Creates a styled text fragment from the current string setting the ANSI color provided as the background color.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the fragment.
    public func onANSI(_ color: ANSIColor) -> StyledTextFragment {
        .init(self, style: .init(background: .ansi(color)))
    }

    /// Creates a styled text fragment from the current string setting the sRGB color provided as the background color.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the fragment.
    public func onSRGB(_ color: SRGBColor) -> StyledTextFragment {
        .init(self, style: .init(background: .srgb(color)))
    }

    /// Creates a styled text fragment from the current string setting the sRGB color created from the components provided as the background color.
    ///
    /// - Parameter red: the red component of the color.
    /// - Parameter green: the green component of the color.
    /// - Parameter blue: the blue component of the color.
    /// - Returns: the fragment.
    public func onSRGB(red: SRGBColor.Component, green: SRGBColor.Component, blue: SRGBColor.Component) -> StyledTextFragment {
        .init(self, style: .init(background: .srgb(.init(red: red, green: green, blue: blue))))
    }

    /// Creates a styled text fragment from the current string setting a color in a text layer.
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
        return .init(self, style: style)
    }

    /// Creates a styled text fragment from the current string setting bold as the text weight.
    public var bold: StyledTextFragment { .init(self, style: .init(weight: .bold)) }
    /// Creates a styled text fragment from the current string setting dim as the text weight.
    public var dim: StyledTextFragment { .init(self, style: .init(weight: .dim)) }

    /// Creates a styled text fragment from the current string setting the text weight provided.
    ///
    /// - Parameter weight: the weight to be applied.
    /// - Returns: the fragment.
    public func weight(_ weight: TextWeight) -> StyledTextFragment {
        .init(self, style: .init(weight: weight))
    }

    /// Creates a styled text fragment from the current string setting italic as an active effect.
    public var italic: StyledTextFragment { .init(self, style: .init(effects: [.italic])) }
    /// Creates a styled text fragment from the current string setting underline as an active effect.
    public var underline: StyledTextFragment { .init(self, style: .init(effects: [.underline])) }
    /// Creates a styled text fragment from the current string setting blinking as an active effect.
    public var blinking: StyledTextFragment { .init(self, style: .init(effects: [.blinking])) }
    /// Creates a styled text fragment from the current string setting inverted layers as an active effect.
    public var invertedLayers: StyledTextFragment { .init(self, style: .init(effects: [.invertedLayers])) }
    /// Creates a styled text fragment from the current string setting strikethrough as an active effect.
    public var strikethrough: StyledTextFragment { .init(self, style: .init(effects: [.strikethrough])) }

    /// Creates a styled text fragment from the current string setting the effects provided as active.
    ///
    /// - Parameter effects: the effects to be activated.
    /// - Returns: the fragment.
    @available(*, deprecated, message: "Use the overload that accepts a Set<TextEffect> or specific effect methods.")
    public func effects(_ effects: TextEffect...) -> StyledTextFragment {
        .init(self, style: .init(effects: Set(effects)))
    }

    /// Creates a styled text fragment from the current string setting the effects provided as active.
    ///
    /// - Parameter effects: the effects to be activated.
    /// - Returns: the fragment.
    public func effects(_ effects: Set<TextEffect>) -> StyledTextFragment {
        .init(self, style: .init(effects: effects))
    }

    /// Creates a styled text fragment from the current string setting the padding provided.
    ///
    /// - Parameter padding: the padding to be applied.
    /// - Returns: the fragment.
    public func pad(using padding: TextPadding) -> StyledTextFragment {
        .init(self, style: .init(padding: padding))
    }

    /// Creates a styled text fragment from the current string setting the padding created from the components provided.
    ///
    /// - Parameter alignment: the alignment for the text being padded.
    /// - Parameter character: the character to pad with.
    /// - Parameter length: the length for the padding, including the text area.
    /// - Returns: the fragment.
    public func pad(_ alignment: TextAlignment, with character: Character = " ", by length: Terminal.Size) -> StyledTextFragment {
        .init(self, style: .init(padding: .init(alignment, with: character, by: length)))
    }

    /// Creates a styled text fragment from the current string setting the style provided.
    ///
    /// - Parameter style: the style to be applied.
    /// - Returns: the fragment.
    public func style(_ style: TextStyle) -> StyledTextFragment {
        .init(self, style: style)
    }
}
