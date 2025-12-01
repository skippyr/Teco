//
//  StyledText+Styles.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros <skippyr.developer@icloud.com>
//  Visit my website: https://dragonscave.xyz.
//  Follow me on GitHub: https://github.com/skippyr.
//
//  Refer to the LICENSE file that comes in its source code for more details.
//  If not available, all rights are reserved to the author.
//

extension StyledText {
    fileprivate func fromCopiedFragments(action: (StyledTextFragment) -> StyledTextFragment) -> StyledText {
        StyledText(fragments.map(action))
    }

    /// Creates a copy of the styled text, setting ANSI black as the foreground color of all of its fragments.
    ///
    /// This color usually matches the terminal background. In light themes, it may be replaced by a near-white shade instead of black.
    public var black: StyledText { fromCopiedFragments { $0.black } }
    /// Creates a copy of the styled text, setting ANSI red as the foreground color of all of its fragments.
    public var red: StyledText { fromCopiedFragments { $0.red } }
    /// Creates a copy of the styled text, setting ANSI green as the foreground color of all of its fragments.
    public var green: StyledText { fromCopiedFragments { $0.green } }
    /// Creates a copy of the styled text, setting ANSI yellow as the foreground color of all of its fragments.
    public var yellow: StyledText { fromCopiedFragments { $0.yellow } }
    /// Creates a copy of the styled text, setting ANSI blue as the foreground color of all of its fragments.
    public var blue: StyledText { fromCopiedFragments { $0.blue } }
    /// Creates a copy of the styled text, setting ANSI magenta as the foreground color of all of its fragments.
    public var magenta: StyledText { fromCopiedFragments { $0.magenta } }
    /// Creates a copy of the styled text, setting ANSI cyan as the foreground color of all of its fragments.
    public var cyan: StyledText { fromCopiedFragments { $0.cyan } }
    /// Creates a copy of the styled text, setting ANSI bright white as the foreground color of all of its fragments.
    ///
    /// This color usually matches the terminal foreground. In light themes, it may be replaced by a near-black shade instead of white.
    public var white: StyledText { fromCopiedFragments { $0.white } }
    /// Creates a copy of the styled text, setting ANSI bright black as the foreground color of all of its fragments.
    ///
    /// This color is usually a darker shade of the terminal foreground, useful for captions.
    public var gray: StyledText { fromCopiedFragments { $0.gray } }

    /// Creates a copy of the styled text, setting the ANSI color provided as the foreground color of all of its fragments.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the copy.
    public func ansi(_ color: ANSIColor) -> StyledText {
        fromCopiedFragments { $0.ansi(color) }
    }

    @available(*, deprecated, renamed: "sRGB")
    public func srgb(_ color: SRGBColor) -> StyledText {
        sRGB(color)
    }

    /// Creates a copy of the styled text, setting the sRGB color provided as the foreground color of all of its fragments.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the copy.
    public func sRGB(_ color: SRGBColor) -> StyledText {
        fromCopiedFragments { $0.sRGB(color) }
    }

    @available(*, deprecated, renamed: "sRGB")
    public func srgb(red: SRGBColor.Component, green: SRGBColor.Component, blue: SRGBColor.Component) -> StyledText {
        sRGB(red: red, green: green, blue: blue)
    }

    /// Creates a copy of the styled text, setting the sRGB color created from the components provided as the foreground color of all of its fragments.
    ///
    /// - Parameter red: the red component of the color
    /// - Parameter green: the green component of the color
    /// - Parameter blue: the blue component of the color
    /// - Returns: the copy.
    public func sRGB(red: SRGBColor.Component, green: SRGBColor.Component, blue: SRGBColor.Component) -> StyledText {
        fromCopiedFragments { $0.sRGB(red: red, green: green, blue: blue) }
    }

    /// Creates a copy of the styled text, setting ANSI red as the background color of all of its fragments.
    public var onRed: StyledText { fromCopiedFragments { $0.onRed } }
    /// Creates a copy of the styled text, setting ANSI green as the background color of all of its fragments.
    public var onGreen: StyledText { fromCopiedFragments { $0.onGreen } }
    /// Creates a copy of the styled text, setting ANSI yellow as the background color of all of its fragments.
    public var onYellow: StyledText { fromCopiedFragments { $0.onYellow } }
    /// Creates a copy of the styled text, setting ANSI blue as the background color of all of its fragments.
    public var onBlue: StyledText { fromCopiedFragments { $0.onBlue } }
    /// Creates a copy of the styled text, setting ANSI magenta as the background color of all of its fragments.
    public var onMagenta: StyledText { fromCopiedFragments { $0.onMagenta } }
    /// Creates a copy of the styled text, setting ANSI cyan as the background color of all of its fragments.
    public var onCyan: StyledText { fromCopiedFragments { $0.onCyan } }
    /// Creates a copy of the styled text, setting ANSI bright white as the background color of all of its fragments.
    ///
    /// This color usually matches the terminal foreground. In light themes, it may be replaced by a near-black shade instead of white.
    ///
    /// If you're planning to invert the colors of a text, prefer to use the inverted layers effect.
    public var onWhite: StyledText { fromCopiedFragments { $0.onWhite } }
    /// Creates a copy of the styled text, setting ANSI bright gray as the background color of all of its fragments.
    public var onGray: StyledText { fromCopiedFragments { $0.onGray } }

    /// Creates a copy of the styled text, setting the ANSI color provided as the background color of all of its fragments.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the copy.
    public func onANSI(_ color: ANSIColor) -> StyledText {
        fromCopiedFragments { $0.onANSI(color) }
    }

    /// Creates a copy of the styled text, setting the sRGB color provided as the background color of all of its fragments.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the copy.
    public func onSRGB(_ color: SRGBColor) -> StyledText {
        fromCopiedFragments { $0.onSRGB(color) }
    }

    /// Creates a copy of the styled text, setting the sRGB color created from the components provided as the background color of all of its fragments.
    ///
    /// - Parameter red: the red component of the color
    /// - Parameter green: the green component of the color
    /// - Parameter blue: the blue component of the color
    /// - Returns: the copy.
    public func onSRGB(red: SRGBColor.Component, green: SRGBColor.Component, blue: SRGBColor.Component) -> StyledText {
        fromCopiedFragments { $0.onSRGB(red: red, green: green, blue: blue) }
    }

    /// Creates a copy of the styled text, setting a color in a text layer of all of its fragments.
    ///
    /// - Parameter color: the color to be applied.
    /// - Parameter layer: the layer to be affected.
    /// - Returns: the copy.
    public func color(_ color: Color, at layer: TextLayer) -> StyledText {
        fromCopiedFragments { $0.color(color, at: layer) }
    }

    /// Creates a copy of the styled text, setting bold as the text weight of all of its fragments.
    public var bold: StyledText { fromCopiedFragments { $0.bold } }
    /// Creates a copy of the styled text, setting dim as the text weight as the text weight of all of its fragments.
    public var dim: StyledText { fromCopiedFragments { $0.dim } }

    /// Creates a copy of the styled text, setting the text weight provided on all of its fragments.
    ///
    /// - Parameter weight: the weight to be applied.
    /// - Returns: the copy.
    public func weight(_ weight: TextWeight) -> StyledText {
        fromCopiedFragments { $0.weight(weight) }
    }

    /// Creates a copy of the styled text, setting italic as an active effect on all of its fragments.
    public var italic: StyledText { fromCopiedFragments { $0.italic } }
    /// Creates a copy of the styled text, setting underline as an active effect on all of its fragments.
    public var underline: StyledText { fromCopiedFragments { $0.underline } }
    @available(*, deprecated, renamed: "blink")
    public var blinking: StyledText { blink }
    /// Creates a copy of the styled text, setting blink as an active effect on all of its fragments.
    public var blink: StyledText { fromCopiedFragments { $0.blink } }
    @available(*, deprecated, renamed: "swapLayers")
    public var invertedLayers: StyledText { swapLayers }
    /// Creates a copy of the styled text, setting swap layers as an active effect on all of its fragments.
    public var swapLayers: StyledText { fromCopiedFragments { $0.swapLayers } }
    /// Creates a copy of the styled text, setting strikethrough as an active effect on all of its fragments.
    public var strikethrough: StyledText { fromCopiedFragments { $0.strikethrough } }

    @available(*, deprecated, message: "Use the overload that accepts a Set<TextEffect> or specific effect methods.")
    public func effects(_ effects: TextEffect...) -> StyledTextFragment {
        self.effects(Set(effects))
    }

    /// Creates a copy of the styled text, setting the effects provided as active on all of its fragments.
    ///
    /// - Parameter effects: the effects to be activated.
    /// - Returns: the copy.
    public func effects(_ effects: Set<TextEffect>) -> StyledText {
        fromCopiedFragments { $0.effects(effects) }
    }

    /// Creates a copy of the styled text, setting the padding provided.
    ///
    /// Depending on the amount of fragments available, the algorithm may apply the padding to only one fragment or split between the ones at the edges. Existing padding in the affected fragments may be removed or modified.
    ///
    /// - Parameter padding: the padding to be applied.
    /// - Returns: the copy.
    public func pad(using padding: TextPadding) -> StyledText {
        guard fragments.count > 1 else {
            return StyledText(fragments.first!.pad(using: padding))
        }
        var fragments = self.fragments
        let lastOffset = fragments.count - 1
        fragments[0].style.padding = nil
        fragments[lastOffset].style.padding = nil
        let stringCount = StyledText(fragments).count
        switch padding.alignment {
        case .center:
            let totalPaddingLength = max(0, Int(padding.length) - stringCount)
            let leftPaddingLength = totalPaddingLength / 2
            let rightPaddingLength = totalPaddingLength - leftPaddingLength
            fragments[0].style.padding = .init(.right, by: CellUnit(leftPaddingLength + fragments[0].count))
            fragments[lastOffset].style.padding = .init(.left, by: CellUnit(rightPaddingLength + fragments[lastOffset].count))
        case let alignment:
            let paddingLength = Int(padding.length) - stringCount
            if paddingLength > 0 {
                let offset = alignment == .left ? lastOffset : 0
                fragments[offset].style.padding = .init(alignment, by: CellUnit(paddingLength + fragments[offset].count))
            }
        }
        return StyledText(fragments)
    }

    /// Creates a copy of the styled text, setting the padding created from the components provided.
    ///
    /// Depending on the amount of fragments available, the algorithm may apply the padding to only one fragment or split between the ones at the edges. Existing padding in the affected fragments may be removed or modified.
    ///
    /// - Parameter alignment: the alignment for the text being padded.
    /// - Parameter character: the character to pad with.
    /// - Parameter length: the length for the padding, including the text area.
    /// - Returns: the copy.
    public func pad(_ alignment: TextAlignment, with character: Character = " ", by length: CellUnit) -> StyledText {
        pad(using: .init(alignment, with: character, by: length))
    }

    /// Creates a copy of the styled text, setting the style provided.
    ///
    /// All style properties, except padding, are applied to all of its fragments.
    ///
    /// In the case of padding, depending on the amount of fragments available, the algorithm may apply the padding to only one fragment or split between the ones at the edges. Existing padding in the affected fragments may be removed or modified.
    ///
    /// - Parameter style: the style to be applied.
    /// - Returns: the copy.
    public func style(_ style: TextStyle) -> StyledText {
        var styleWithoutPadding = style
        styleWithoutPadding.padding = nil
        let styledText = fromCopiedFragments { $0.style(styleWithoutPadding) }
        return if let padding = style.padding {
            styledText.pad(using: padding)
        } else {
            styledText
        }
    }
}
