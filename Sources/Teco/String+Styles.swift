//
//  String+Styles.swift
//  Teco
//
//  Created by Sherman Barros on 11/17/25.
//

extension String {
    func rawPad(using padding: Terminal.Padding) -> String {
        let count = max(0, Int(padding.length) - count)
        switch padding.alignment {
        case .left:
            return self + String(repeating: padding.character, count: count)
        case .right:
            return String(repeating: padding.character, count: count) + self
        case .center:
            let leftCount = count / 2
            let rightCount = count - leftCount
            return String(repeating: padding.character, count: leftCount) + self
                + String(repeating: padding.character, count: rightCount)
        }
    }

    /// Creates a styled fragment from the current string setting ANSI black as the foreground color.
    ///
    /// This color usually matches the terminal background. In light themes, it may be replaced by a near-white shade instead of black.
    public var black: Terminal.StyledFragment {
        .init(self, style: .init(foreground: .black))
    }

    /// Creates a styled fragment from the current string setting ANSI red as the foreground color.
    public var red: Terminal.StyledFragment {
        .init(self, style: .init(foreground: .red))
    }

    /// Creates a styled fragment from the current string setting ANSI green as the foreground color.
    public var green: Terminal.StyledFragment {
        .init(self, style: .init(foreground: .green))
    }

    /// Creates a styled fragment from the current string setting ANSI yellow as the foreground color.
    public var yellow: Terminal.StyledFragment {
        .init(self, style: .init(foreground: .yellow))
    }

    /// Creates a styled fragment from the current string setting ANSI blue as the foreground color.
    public var blue: Terminal.StyledFragment {
        .init(self, style: .init(foreground: .blue))
    }

    /// Creates a styled fragment from the current string setting ANSI magenta as the foreground color.
    public var magenta: Terminal.StyledFragment {
        .init(self, style: .init(foreground: .magenta))
    }

    /// Creates a styled fragment from the current string setting ANSI cyan as the foreground color.
    public var cyan: Terminal.StyledFragment {
        .init(self, style: .init(foreground: .cyan))
    }

    /// Creates a styled fragment from the current string setting ANSI bright white as the foreground color.
    ///
    /// This color usually matches the terminal foreground. In light themes, it may be replaced by a near-black shade instead of white.
    public var white: Terminal.StyledFragment {
        .init(self, style: .init(foreground: .white))
    }

    /// Creates a styled fragment from the current string setting ANSI bright black as the foreground color.
    ///
    /// This color is usually a darker shade of the terminal foreground, useful for captions.
    public var gray: Terminal.StyledFragment {
        .init(self, style: .init(foreground: .gray))
    }

    /// Creates a styled fragment from the current string setting the ANSI color provided as the foreground color.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the fragment.
    public func ansi(_ color: Terminal.ANSIColor) -> Terminal.StyledFragment {
        .init(self, style: .init(foreground: .ansi(color)))
    }

    /// Creates a styled fragment from the current string setting the sRGB color provided as the foreground color.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the fragment.
    public func srgb(_ color: Terminal.SRGBColor) -> Terminal.StyledFragment {
        .init(self, style: .init(foreground: .srgb(color)))
    }

    /// Creates a styled fragment from the current string setting the sRGB color created from the components provided as the foreground color.
    ///
    /// - Parameter red: the red component.
    /// - Parameter green: the green component.
    /// - Parameter blue: the blue component.
    /// - Returns: the fragment.
    public func srgb(
        red: Terminal.SRGBColor.Component, green: Terminal.SRGBColor.Component, blue: Terminal.SRGBColor.Component
    ) -> Terminal.StyledFragment {
        .init(self, style: .init(foreground: .srgb(.init(red: red, green: green, blue: blue))))
    }

    /// Creates a styled fragment from the current string setting ANSI red as the background color.
    public var onRed: Terminal.StyledFragment {
        .init(self, style: .init(background: .red))
    }

    /// Creates a styled fragment from the current string setting ANSI green as the background color.
    public var onGreen: Terminal.StyledFragment {
        .init(self, style: .init(background: .green))
    }

    /// Creates a styled fragment from the current string setting ANSI yellow as the background color.
    public var onYellow: Terminal.StyledFragment {
        .init(self, style: .init(background: .yellow))
    }

    /// Creates a styled fragment from the current string setting ANSI blue as the background color.
    public var onBlue: Terminal.StyledFragment {
        .init(self, style: .init(background: .blue))
    }

    /// Creates a styled fragment from the current string setting ANSI magenta as the background color.
    public var onMagenta: Terminal.StyledFragment {
        .init(self, style: .init(background: .magenta))
    }

    /// Creates a styled fragment from the current string setting ANSI cyan as the background color.
    public var onCyan: Terminal.StyledFragment {
        .init(self, style: .init(background: .cyan))
    }

    /// Creates a styled fragment from the current string setting ANSI bright white as the background color.
    ///
    /// This color usually matches the terminal foreground. In light themes, it may be replaced with one closer to black.
    public var onWhite: Terminal.StyledFragment {
        .init(self, style: .init(background: .white))
    }

    /// Creates a styled fragment from the current string setting ANSI bright black as the background color.
    public var onGray: Terminal.StyledFragment {
        .init(self, style: .init(background: .gray))
    }

    /// Creates a styled fragment from the current string setting the ANSI color provided as the background color.
    ///
    /// - Returns: the fragment.
    public func onANSI(_ color: Terminal.ANSIColor) -> Terminal.StyledFragment {
        .init(self, style: .init(background: .ansi(color)))
    }

    /// Creates a styled fragment from the current string setting the sRGB color provided as the background color.
    ///
    /// - Returns: the fragment.
    public func onSRGB(_ color: Terminal.SRGBColor) -> Terminal.StyledFragment {
        .init(self, style: .init(background: .srgb(color)))
    }

    /// Creates a styled fragment from the current string setting the sRGB color created from the components provided as the background color.
    ///
    /// - Returns: the fragment.
    public func onSRGB(
        red: Terminal.SRGBColor.Component, green: Terminal.SRGBColor.Component, blue: Terminal.SRGBColor.Component
    ) -> Terminal.StyledFragment {
        .init(self, style: .init(background: .srgb(.init(red: red, green: green, blue: blue))))
    }

    /// Creates a styled fragment from the current string setting a color in a text layer.
    ///
    /// - Parameter color: the color to be applied.
    /// - Parameter layer: the layer to be affected.
    /// - Returns: the fragment.
    public func color(_ color: Terminal.Color, at layer: Terminal.Layer) -> Terminal.StyledFragment {
        var style = Terminal.Style()
        switch layer {
        case .foreground:
            style.foreground = color
        case .background:
            style.background = color
        }
        return .init(self, style: style)
    }

    /// Creates a styled fragment from the current string setting bold as the font weight.
    public var bold: Terminal.StyledFragment {
        .init(self, style: .init(weight: .bold))
    }

    /// Creates a styled fragment from the current string setting dim as the font weight.
    public var dim: Terminal.StyledFragment {
        .init(self, style: .init(weight: .dim))
    }

    /// Creates a styled fragment from the current string setting the font weight provided.
    ///
    /// - Parameter weight: the weight to be applied.
    /// - Returns: the fragment.
    public func weight(_ weight: Terminal.Weight) -> Terminal.StyledFragment {
        .init(self, style: .init(weight: weight))
    }

    /// Creates a styled fragment from the current string setting italic as an active effect.
    public var italic: Terminal.StyledFragment {
        .init(self, style: .init(effects: [.italic]))
    }

    /// Creates a styled fragment from the current string setting underline as an active effect.
    public var underline: Terminal.StyledFragment {
        .init(self, style: .init(effects: [.underline]))
    }

    /// Creates a styled fragment from the current string setting blinking as an active effect.
    public var blinking: Terminal.StyledFragment {
        .init(self, style: .init(effects: [.blinking]))
    }

    /// Creates a styled fragment from the current string setting inverted layers as an active effect.
    public var invertedLayers: Terminal.StyledFragment {
        .init(self, style: .init(effects: [.invertedLayers]))
    }

    /// Creates a styled fragment from the current string setting strikethrough as an active effect.
    public var strikethrough: Terminal.StyledFragment {
        .init(self, style: .init(effects: [.strikethrough]))
    }

    /// Creates a styled fragment from the current string setting the effects provided as active.
    ///
    /// - Parameter effects: the effects to be activated.
    /// - Returns: the fragment.
    public func effects(_ effects: Terminal.Effect...) -> Terminal.StyledFragment {
        .init(self, style: .init(effects: Set(effects)))
    }

    /// Creates a styled fragment from the current string setting the effects provided as active.
    ///
    /// - Parameter effects: the effects to be activated.
    /// - Returns: the fragment.
    public func effects(_ effects: Set<Terminal.Effect>) -> Terminal.StyledFragment {
        .init(self, style: .init(effects: effects))
    }

    /// Creates a styled fragment from the current string setting the padding provided.
    ///
    /// - Parameter padding: the padding to be used.
    /// - Returns: the modified copy.
    public func pad(using padding: Terminal.Padding) -> Terminal.StyledFragment {
        .init(self, style: .init(padding: padding))
    }

    /// Creates a styled fragment from the current string setting the padding created from the components provided.
    ///
    /// - Parameter alignment: the alignment for the text being padded.
    /// - Parameter character: the character to pad with.
    /// - Parameter length: the length for the padding, including the text area.
    /// - Returns: the fragment.
    public func pad(_ alignment: Terminal.Alignment, with character: Character = " ", by length: Terminal.Size)
        -> Terminal.StyledFragment
    {
        .init(self, style: .init(padding: .init(alignment, with: character, by: length)))
    }

    /// Creates a styled fragment from the current string setting the style provided.
    ///
    /// - Parameter style: the style to be applied.
    /// - Returns: the fragment.
    public func style(_ style: Terminal.Style) -> Terminal.StyledFragment {
        .init(self, style: style)
    }
}
