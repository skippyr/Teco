//
//  StyledFragment+Styles.swift
//  Teco
//
//  Created by Sherman Barros on 11/17/25.
//

import Foundation

extension Terminal.StyledFragment {
    fileprivate func appendingStyle(
        foreground: Terminal.Color? = nil, background: Terminal.Color? = nil, weight: Terminal.Weight? = nil,
        effects: Set<Terminal.Effect>? = nil, padding: Terminal.Padding? = nil
    ) -> Terminal.StyledFragment {
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
    /// This color usually matches the terminal background. In light themes, it may be replaced with one closer to white.
    public var black: Terminal.StyledFragment {
        appendingStyle(foreground: .black)
    }

    /// Returns a copy of the current fragment setting ANSI red as the foreground color.
    public var red: Terminal.StyledFragment {
        appendingStyle(foreground: .red)
    }

    /// Returns a copy of the current fragment setting ANSI green as the foreground color.
    public var green: Terminal.StyledFragment {
        appendingStyle(foreground: .green)
    }

    /// Returns a copy of the current fragment setting ANSI yellow as the foreground color.
    public var yellow: Terminal.StyledFragment {
        appendingStyle(foreground: .yellow)
    }

    /// Returns a copy of the current fragment setting ANSI blue as the foreground color.
    public var blue: Terminal.StyledFragment {
        appendingStyle(foreground: .blue)
    }

    /// Returns a copy of the current fragment setting ANSI magenta as the foreground color.
    public var magenta: Terminal.StyledFragment {
        appendingStyle(foreground: .magenta)
    }

    /// Returns a copy of the current fragment setting ANSI cyan as the foreground color.
    public var cyan: Terminal.StyledFragment {
        appendingStyle(foreground: .cyan)
    }

    /// Returns a copy of the current fragment setting ANSI bright white as the foreground color.
    ///
    /// This color usually matches the terminal foreground. In light themes, it may be replaced with one closer to black.
    public var white: Terminal.StyledFragment {
        appendingStyle(foreground: .white)
    }

    /// Returns a copy of the current fragment setting ANSI bright black as the foreground color.
    ///
    /// This color is usually a darker shade of the terminal foreground, useful for captions.
    public var gray: Terminal.StyledFragment {
        appendingStyle(foreground: .gray)
    }

    /// Returns a copy of the current fragment setting the ANSI color provided as the foreground color.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the modified copy.
    public func ansi(_ color: Terminal.ANSIColor) -> Terminal.StyledFragment {
        appendingStyle(foreground: .ansi(color))
    }

    /// Returns a copy of the current fragment setting the sRGB color provided as the foreground color.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the modified copy.
    public func srgb(_ color: Terminal.SRGBColor) -> Terminal.StyledFragment {
        appendingStyle(foreground: .srgb(color))
    }

    /// Returns a copy of the current fragment setting the sRGB color created from the components provided as the foreground color.
    ///
    /// - Parameter red: the red component.
    /// - Parameter green: the green component.
    /// - Parameter blue: the blue component.
    /// - Returns: the modified copy.
    public func srgb(
        red: Terminal.SRGBColor.Component, green: Terminal.SRGBColor.Component, blue: Terminal.SRGBColor.Component
    ) -> Terminal.StyledFragment {
        appendingStyle(foreground: .srgb(.init(red: red, green: green, blue: blue)))
    }

    /// Returns a copy of the current fragment setting ANSI red as the background color.
    public var onRed: Terminal.StyledFragment {
        appendingStyle(background: .red)
    }

    /// Returns a copy of the current fragment setting ANSI green as the background color.
    public var onGreen: Terminal.StyledFragment {
        appendingStyle(background: .green)
    }

    /// Returns a copy of the current fragment setting ANSI yellow as the background color.
    public var onYellow: Terminal.StyledFragment {
        appendingStyle(background: .yellow)
    }

    /// Returns a copy of the current fragment setting ANSI blue as the background color.
    public var onBlue: Terminal.StyledFragment {
        appendingStyle(background: .blue)
    }

    /// Returns a copy of the current fragment setting ANSI magenta as the background color.
    public var onMagenta: Terminal.StyledFragment {
        appendingStyle(background: .magenta)
    }

    /// Returns a copy of the current fragment setting ANSI cyan as the background color.
    public var onCyan: Terminal.StyledFragment {
        appendingStyle(background: .cyan)
    }

    /// Returns a copy of the current fragment setting ANSI bright white as the background color.
    ///
    /// This color usually matches the terminal foreground. In light themes, it may be replaced with one closer to black.
    ///
    /// If you're planning to invert the colors of your text, prefer to use the `invertedLayers` effect instead via the method with same name.
    public var onWhite: Terminal.StyledFragment {
        appendingStyle(background: .white)
    }

    /// Returns a copy of the current fragment setting ANSI bright black as the background color.
    public var onGray: Terminal.StyledFragment {
        appendingStyle(background: .gray)
    }

    /// Returns a copy of the current fragment setting the ANSI color provided as the background color.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the modified copy.
    public func onANSI(_ color: Terminal.ANSIColor) -> Terminal.StyledFragment {
        appendingStyle(background: .ansi(color))
    }

    /// Returns a copy of the current fragment setting the sRGB color provided as the background color.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the modified copy.
    public func onSRGB(_ color: Terminal.SRGBColor) -> Terminal.StyledFragment {
        appendingStyle(background: .srgb(color))
    }

    /// Returns a copy of the current fragment setting the sRGB color created from the components provided as the background color.
    ///
    /// - Parameter red: the red component.
    /// - Parameter green: the green component.
    /// - Parameter blue: the blue component.
    /// - Returns: the modified copy.
    public func onSRGB(
        red: Terminal.SRGBColor.Component, green: Terminal.SRGBColor.Component, blue: Terminal.SRGBColor.Component
    ) -> Terminal.StyledFragment {
        appendingStyle(background: .srgb(.init(red: red, green: green, blue: blue)))
    }

    /// Returns a copy of the current fragment setting a color in a text layer.
    ///
    /// - Parameter color: the color to be applied.
    /// - Parameter layer: the layer to be affected.
    /// - Returns: the modified copy.
    public func color(_ color: Terminal.Color, at layer: Terminal.Layer) -> Terminal.StyledFragment {
        switch layer {
        case .foreground:
            appendingStyle(foreground: color)
        case .background:
            appendingStyle(background: color)
        }
    }

    /// Returns a copy of the current fragment setting bold as the font weight.
    public var bold: Terminal.StyledFragment {
        appendingStyle(weight: .bold)
    }

    /// Returns a copy of the current fragment setting dim as the font weight.
    public var dim: Terminal.StyledFragment {
        appendingStyle(weight: .dim)
    }

    /// Returns a copy of the current fragment setting the font weight provided.
    ///
    /// - Parameter weight: the weight to be applied.
    /// - Returns: the modified copy.
    public func weight(_ weight: Terminal.Weight) -> Terminal.StyledFragment {
        appendingStyle(weight: weight)
    }

    /// Returns a copy of the current fragment setting italic as an active effect.
    public var italic: Terminal.StyledFragment {
        appendingStyle(effects: [.italic])
    }

    /// Returns a copy of the current fragment setting underline as an active effect.
    public var underline: Terminal.StyledFragment {
        appendingStyle(effects: [.underline])
    }

    /// Returns a copy of the current fragment setting blinking as an active effect.
    public var blinking: Terminal.StyledFragment {
        appendingStyle(effects: [.blinking])
    }

    /// Returns a copy of the current fragment setting inverted layers as an active effect.
    public var invertedLayers: Terminal.StyledFragment {
        appendingStyle(effects: [.invertedLayers])
    }

    /// Returns a copy of the current fragment setting strikethrough as an active effect.
    public var strikethrough: Terminal.StyledFragment {
        appendingStyle(effects: [.strikethrough])
    }

    /// Returns a copy of the current fragment setting the effects provided as active.
    ///
    /// - Parameter effects: the effects to be activated.
    /// - Returns: the modified copy.
    public func effects(_ effects: Terminal.Effect...) -> Terminal.StyledFragment {
        appendingStyle(effects: Set(effects))
    }

    /// Returns a copy of the current fragment setting the effects provided as active.
    ///
    /// - Parameter effects: the effects to be activated.
    /// - Returns: the modified copy.
    public func effects(_ effects: Set<Terminal.Effect>) -> Terminal.StyledFragment {
        appendingStyle(effects: effects)
    }

    /// Returns a copy of the current fragment setting the padding provided.
    ///
    /// - Parameter padding: the padding to be used.
    /// - Returns: the modified copy.
    public func pad(using padding: Terminal.Padding) -> Terminal.StyledFragment {
        appendingStyle(padding: padding)
    }

    /// Returns a copy of the current fragment setting the padding created from the components provided.
    ///
    /// - Parameter alignment: the alignment for the text being padded.
    /// - Parameter character: the character to pad with.
    /// - Parameter length: the length for the padding, including the text area.
    /// - Returns: the modified copy.
    public func pad(_ alignment: Terminal.Alignment, with character: Character = " ", by length: Terminal.Size)
        -> Terminal.StyledFragment
    {
        appendingStyle(padding: .init(alignment, with: character, by: length))
    }

    /// Returns a copy of the current fragment setting the style provided.
    ///
    /// - Parameter style: the style to be applied.
    /// - Returns: the modified copy.
    public func style(_ style: Terminal.Style) -> Terminal.StyledFragment {
        .init(string, style: style)
    }
}
