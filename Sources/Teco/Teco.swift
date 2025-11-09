//
//  Teco.swift
//  Teco
//
//  Created by Sherman Barros on 10/31/25.
//

import Foundation

/// A handle to manipulate the emulated terminal.
@MainActor
public class Terminal {
    /// A boolean that states the terminal input stream is redirected.
    ///
    /// This value is cached and might stale, even tough that's very unlikely to happen for most apps.
    static public let isInputRedirected: Bool = { isatty(STDIN_FILENO) == 0 }()
    /// A boolean that states the terminal output stream is redirected.
    ///
    /// This value is cached and might stale, even tough that's very unlikely to happen for most apps.
    static public let isOutputRedirected: Bool = { isatty(STDOUT_FILENO) == 0 }()
    /// A boolean that states the terminal error stream is redirected.
    ///
    /// This value is cached and might stale, even tough that's very unlikely to happen for most apps.
    static public let isErrorRedirected: Bool = { isatty(STDERR_FILENO) == 0 }()
    /// A boolean that states terminal styles should be applied.
    ///
    /// By default, it's `false` if the environment variable `NO_COLOR` is set or the terminal identifier (hold by the `TERM` environment variable) is `dumb`—meaning no capabilities supported.
    ///
    /// You can override it to implement custom behavior.
    static public var shouldApplyStyles: Bool = {
        let id = getenv("TERM")
        return getenv("NO_COLOR") == nil && (id != nil && strcmp(id, "dumb") != 0)
    }()
    
    @inline(__always)
    static private func rawWrite(_ string: UnsafePointer<CChar>, via stream: WritableStream) {
        let file = switch stream {
        case .output:
            stdout
        case .error:
            stderr
        }
        fputs(string, file)
    }
    
    /// Writes a styled string to a terminal writable stream, applying the styles described in its fragments if the `shouldApplyStyles` boolean is `true` and the stream is not redirected.
    ///
    /// - Parameter string: the string to be written.
    /// - Parameter terminator: the sequence to be appended at the end of the output.
    /// - Parameter stream: the stream being targeted.
    static public func print(_ string: StyledString, terminator: String = "\n", via stream: WritableStream = .output) {
        let isStreamRedirected = switch stream {
        case .output:
            isOutputRedirected
        case .error:
            isErrorRedirected
        }
        let stylesCanBeApplied = shouldApplyStyles && !isStreamRedirected
        string.fragments.forEach { fragment in
            if stylesCanBeApplied {
                if let foreground = fragment.style.foreground {
                    setColor(foreground, at: .foreground, via: stream)
                }
                if let background = fragment.style.background {
                    setColor(background, at: .background, via: stream)
                }
                if let weight = fragment.style.weight {
                    setWeight(weight, via: stream)
                }
                if let effects = fragment.style.effects {
                    setEffects(effects, via: stream)
                }
            }
            let message = if let padding = fragment.style.padding {
                fragment.string.rawPad(using: padding)
            } else {
                fragment.string
            }
            rawWrite(message, via: stream)
            if stylesCanBeApplied && (fragment.style.foreground != nil || fragment.style.background != nil || fragment.style.weight != nil || (fragment.style.effects != nil && !fragment.style.effects!.isEmpty)) {
                resetStyle(via: stream)
            }
        }
        rawWrite(terminator, via: stream)
    }
    
    /// Writes a styled fragment to a terminal writable stream, applying the styles it describes if the `shouldApplyStyles` boolean is `true` and the stream is not redirected.
    ///
    /// - Parameter fragment: the fragment to be written.
    /// - Parameter terminator: the sequence to be appended at the end of the output.
    /// - Parameter stream: the stream being targeted.
    @inline(__always)
    static public func print(_ fragment: StyledFragment, terminator: String = "\n", via stream: WritableStream = .output) {
        print(StyledString(fragment), terminator: terminator, via: stream)
    }
  
    /// Writes a string to a terminal writable stream.
    ///
    /// - Parameter string: the string to be written.
    /// - Parameter terminator: the sequence to be appended at the end of the output.
    /// - Parameter stream: the stream being targeted.
    @_disfavoredOverload
    @inline(__always)
    static public func print(_ string: String, terminator: String = "\n", via stream: WritableStream = .output) {
        rawWrite(string + terminator, via: stream)
    }
    
    /// Writes the description of an `Any` type to a terminal writable stream.
    ///
    /// The description can be changed by implementing the `CustomStringConvertible` protocol.
    ///
    /// - Parameter item: the item whose description is to be written.
    /// - Parameter terminator: the sequence to be appended at the end of the output.
    /// - Parameter stream: the stream being targeted.
    @_disfavoredOverload
    @inline(__always)
    static public func print(_ item: Any, terminator: String = "\n", via stream: WritableStream = .output)  {
        rawWrite(String(describing: item) + terminator, via: stream)
    }

    /// Writes the newline sequence to a terminal writable stream.
    ///
    /// - Parameter stream: the stream being targeted.
    @inline(__always)
    static public func print(via stream: WritableStream = .output) {
        rawWrite("\n", via: stream)
    }
    
    @inline(__always)
    static private func setColor(_ color: Color, at layer: Layer, via stream: WritableStream) {
        switch color {
        case let .ansi(ansi):
            rawWrite("\u{1b}[\(layer.rawValue)8;5;\(ansi)m", via: stream)
        case let .srgb(rgb):
            rawWrite("\u{1b}[\(layer.rawValue)8;2;\(rgb.red);\(rgb.green);\(rgb.blue)m", via: stream)
        }
    }
    
    @inline(__always)
    static private func setWeight(_ weight: Weight, via stream: WritableStream) {
        rawWrite("\u{1b}[22;\(weight.rawValue)m", via: stream)
    }
    
    @inline(__always)
    static private func setEffects(_ effects: Set<Effect>, via stream: WritableStream) {
        effects.forEach { rawWrite("\u{1b}[\($0.rawValue)m", via: stream) }
    }
    
    @inline(__always)
    static private func resetStyle(via stream: WritableStream) {
        rawWrite("\u{1b}[0m", via: stream)
    }
    
    /// Retrieves the terminal window dimensions.
    ///
    /// - Throws:
    ///   - `Error.streamRedirection`: if all streams are redirected, thus not connected to the window.
    static public var dimensions: Dimensions {
        get throws {
            var systemSize = winsize()
            if (!isInputRedirected && ioctl(STDIN_FILENO, TIOCGWINSZ, &systemSize) == -1 && !isOutputRedirected && ioctl(STDOUT_FILENO, TIOCGWINSZ, &systemSize) == -1 && !isErrorRedirected && ioctl(STDERR_FILENO, TIOCGWINSZ, &systemSize) == -1) {
                throw Error.streamRedirection
            }
            return Dimensions(totalColumns: systemSize.ws_col, totalRows: systemSize.ws_row)
        }
    }

    /// Contains the possible errors related to terminal manipulation.
    public enum Error: Swift.Error {
        /// A set of redirected streams caused an operation to fail.
        case streamRedirection
    }
    
    /// Contains the terminal streams that can be written to.
    public enum WritableStream {
        /// The standard output stream, aka `stdout`. By default, it's line-buffered.
        case output
        /// The standard error stream, aka `stderr`. It's unbuffered.
        case error
    }
    
    /// Contains the terminal text layers where colors can be applied to.
    public enum Layer: UInt8 {
        /// Affects the color of the characters.
        case foreground = 3
        /// Affects the background color behind the characters.
        case background
    }
   
    /// Contains the color formats the terminal can accept.
    public enum Color {
        /// The ANSI black color, equivalent to `.ansi(0)`.
        ///
        /// This color usually matches the background. In light themes, it may be replaced with one closer to white.
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
        /// This color usually matches the foreground. In light themes, it may be replaced with one closer to black.
        public static var white: Color { .ansi(15) }
        /// The ANSI bright black color, equivalent to `.ansi(8)`.
        ///
        /// This color is usually a darker shade of the foreground, useful for captions.
        public static var gray: Color { .ansi(8) }
        
        /// A color of the ANSI 256 color palette.
        ///
        /// - Parameter color: the value of the color.
        case ansi(ANSIColor)
        /// An RGB color described within the sRGB color space.
        ///
        /// - Parameter color: the color.
        case srgb(SRGBColor)
    }
    
    /// Represents a color within the ANSI 256 color palette.
    public typealias ANSIColor = UInt8
   
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
        /// - Parameter green: the green componnt.
        /// - Parameter blue: the blue component.
        public init(red: Component, green: Component, blue: Component) {
            self.red = red
            self.green = green
            self.blue = blue
        }
        
        /// Represents a component of the color.
        public typealias Component = UInt8
    }
    
    /// Contains the available terminal font weights.
    ///
    /// Technically, this refers to the terminal text color brightness, but modern terminals now makes this partially affect font weight.
    public enum Weight: UInt8 {
        /// Makes the text use bold font and/or use bright colors.
        case bold = 1
        /// Makes the text colors faint.
        case dim
    }
    
    /// Contains the most supported terminal text effects.
    public enum Effect: UInt8 {
        /// Makes the text use italic font.
        case italic = 3
        /// Draws a horizontal line below the text.
        case underline
        /// Makes the text blink in slow pace.
        case blinking
        /// Inverts the colors used in the foreground and background layers.
        case invertedLayers = 7
        /// Draws a horizontal line through the text.
        case strikethrough = 9
    }
    
    /// Contains the available alignments for terminal padding.
    public enum Alignment {
        /// Aligns text to the left.
        case left
        /// Aligns text to the right.
        case right
        /// Aligns text in the center.
        case center
    }
    
    /// Contains the information required for performing padding.
    public struct Padding {
        /// The character to pad with.
        public var character: Character
        /// The length for the padding, including the text area.
        public var length: Terminal.Size
        /// The alignment for the text being padded.
        public var alignment: Alignment
        
        /// Creates new information about padding.
        ///
        /// - Parameter alignment: the alignment for the text being padded.
        /// - Parameter character: the character to pad with.
        /// - Parameter length: the length for the padding, including the text area.
        public init(_ alignment: Alignment, with character: Character = " ", by length: Terminal.Size) {
            self.alignment = alignment
            self.character = character
            self.length = length
        }
    }
    
    /// Contains all the terminal style properties a string fragment might have.
    public struct Style {
        /// An optional set containing active effects.
        public var effects: Set<Effect>?
        /// An optional custom padding.
        public var padding: Padding?
        /// An optional custom font weight.
        public var weight: Weight?
        /// An optional custom foreground color.
        public var foreground: Color?
        /// An optional custom background color.
        public var background: Color?

        /// Creates a new style from a list of properties.
        ///
        /// - Parameter foreground: an optional custom foreground color.
        /// - Parameter background: an optional custom background color.
        /// - Parameter weight: an optional custom font weight.
        /// - Parameter effects: an optional set containing active effects.
        /// - Parameter padding: an optional custom padding.
        public init(foreground: Color? = nil, background: Color? = nil, weight: Weight? = nil, effects: Set<Effect>? = nil, padding: Padding? = nil) {
            self.foreground = foreground
            self.background = background
            self.weight = weight
            self.effects = effects
            self.padding = padding
        }
    }
    
    /// Associates a string with a style.
    public struct StyledFragment: CustomStringConvertible {
        /// The string being wrapped.
        private var _string: String
        /// The style applied to the string.
        public var style: Style
        
        /// Creates a new fragment from a string.
        ///
        /// - Parameter string: the string to be wrapped.
        /// - Parameter style: the style to associated it with it.
        public init(_ string: String, style: Style = .init()) {
            _string = string
            self.style = style
        }
        
        /// Retrieves and sets the string being wrapped.
        ///
        /// If the style specifies a custom padding, the string retrieved will have it applied.
        public var string: String {
            get {
                if let padding = style.padding {
                    _string.rawPad(using: padding)
                } else {
                    _string
                }
            }
            set {
                _string = newValue
            }
        }
        
        public var description: String {
            string
        }
    }
   
    /// Glues styled fragments together in order.
    public struct StyledString: ExpressibleByStringInterpolation, CustomStringConvertible {
        /// The fragments being glued.
        public let fragments: [StyledFragment]

        /// Creates a styled string from the description of an `Any` type.
        ///
        /// The description can be changed by implementing the `CustomStringConvertible` protocol.
        ///
        /// - Parameter item: the item whose description is to be wrapped.
        public init(_ item: Any) {
            let description = String(describing: item)
            fragments = description.isEmpty ? [] : [.init(description)]
        }
        
        /// Creates a styled string from a styled fragment.
        ///
        /// - Parameter fragment: the fragment to be considered.
        public init(_ fragment: StyledFragment) {
            fragments = fragment.string.isEmpty ? [] : [fragment]
        }
        
        public init(stringLiteral: String) {
            fragments = stringLiteral.isEmpty ? [] : [.init(stringLiteral)]
        }
        
        public init(stringInterpolation: StringInterpolation) {
            fragments = stringInterpolation.fragments
        }
        
        /// Retrieves the concatenation of the strings its fragments have, allocating the result on the heap.
        ///
        /// Fragments that specifies custom paddings will have their strings with them applied.
        public var string: String {
            fragments.map(\.string).joined()
        }

        public var description: String {
            string
        }
        
        public struct StringInterpolation: StringInterpolationProtocol {
            var fragments: [StyledFragment]
            
            public init(literalCapacity: Int, interpolationCount: Int) {
                fragments = []
                fragments.reserveCapacity(literalCapacity + interpolationCount)
            }
            
            mutating public func appendLiteral(_ literal: StringLiteralType) {
                if !literal.isEmpty {
                    fragments.append(.init(literal))
                }
            }
            
            mutating public func appendInterpolation(_ fragment: StyledFragment) {
                if !fragment.string.isEmpty {
                    fragments.append(fragment)
                }
            }
            
            mutating public func appendInterpolation(_ string: StyledString) {
                fragments.append(contentsOf: string.fragments.filter { !$0.string.isEmpty })
            }
            
            mutating public func appendInterpolation(_ value: Any) {
                let string = String(describing: value)
                if !string.isEmpty {
                    fragments.append(.init(string))
                }
            }
        }
    }
    
    /// Represents the dimensions of the terminal window.
    public struct Dimensions {
        /// The total columns in the dimensions.
        public let totalColumns: Size
        /// The total rows in the dimensions.
        public let totalRows: Size
       
        /// Creates new dimensions based on its components.
        ///
        /// - Parameter totalColumns: the total columns in the dimensions.
        /// - Parameter totalRows: the total rows in the dimensions.
        public init(totalColumns: Size, totalRows: Size) {
            self.totalColumns = totalColumns
            self.totalRows = totalRows
        }
    }
    
    /// Represents the unit used for terminal size measurements.
    public typealias Size = UInt16
}

public extension Terminal.StyledFragment {
    @inline(__always)
    fileprivate func appendingStyle(foreground: Terminal.Color? = nil, background: Terminal.Color? = nil, weight: Terminal.Weight? = nil, effects: Set<Terminal.Effect>? = nil, padding: Terminal.Padding? = nil) -> Terminal.StyledFragment {
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
    @inline(__always)
    var black: Terminal.StyledFragment {
        appendingStyle(foreground: .black)
    }
   
    /// Returns a copy of the current fragment setting ANSI red as the foreground color.
    @inline(__always)
    var red: Terminal.StyledFragment {
        appendingStyle(foreground: .red)
    }
    
    /// Returns a copy of the current fragment setting ANSI green as the foreground color.
    @inline(__always)
    var green: Terminal.StyledFragment {
        appendingStyle(foreground: .green)
    }
   
    /// Returns a copy of the current fragment setting ANSI yellow as the foreground color.
    @inline(__always)
    var yellow: Terminal.StyledFragment {
        appendingStyle(foreground: .yellow)
    }
    
    /// Returns a copy of the current fragment setting ANSI blue as the foreground color.
    @inline(__always)
    var blue: Terminal.StyledFragment {
        appendingStyle(foreground: .blue)
    }
    
    /// Returns a copy of the current fragment setting ANSI magenta as the foreground color.
    @inline(__always)
    var magenta: Terminal.StyledFragment {
        appendingStyle(foreground: .magenta)
    }
    
    /// Returns a copy of the current fragment setting ANSI cyan as the foreground color.
    @inline(__always)
    var cyan: Terminal.StyledFragment {
        appendingStyle(foreground: .cyan)
    }
    
    /// Returns a copy of the current fragment setting ANSI bright white as the foreground color.
    ///
    /// This color usually matches the terminal foreground. In light themes, it may be replaced with one closer to black.
    @inline(__always)
    var white: Terminal.StyledFragment {
        appendingStyle(foreground: .white)
    }
    
    /// Returns a copy of the current fragment setting ANSI bright black as the foreground color.
    ///
    /// This color is usually a darker shade of the terminal foreground, useful for captions.
    @inline(__always)
    var gray: Terminal.StyledFragment {
        appendingStyle(foreground: .gray)
    }
    
    /// Returns a copy of the current fragment setting the ANSI color provided as the foreground color.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the modified copy.
    @inline(__always)
    func ansi(_ color: Terminal.ANSIColor) -> Terminal.StyledFragment {
        appendingStyle(foreground: .ansi(color))
    }
    
    /// Returns a copy of the current fragment setting the sRGB color provided as the foreground color.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the modified copy.
    @inline(__always)
    func srgb(_ color: Terminal.SRGBColor) -> Terminal.StyledFragment {
        appendingStyle(foreground: .srgb(color))
    }
    
    /// Returns a copy of the current fragment setting the sRGB color created from the components provided as the foreground color.
    ///
    /// - Parameter red: the red component.
    /// - Parameter green: the green component.
    /// - Parameter blue: the blue component.
    /// - Returns: the modified copy.
    @inline(__always)
    func srgb(red: Terminal.SRGBColor.Component, green: Terminal.SRGBColor.Component, blue: Terminal.SRGBColor.Component) -> Terminal.StyledFragment {
        appendingStyle(foreground: .srgb(.init(red: red, green: green, blue: blue)))
    }

    /// Returns a copy of the current fragment setting ANSI red as the background color.
    @inline(__always)
    var onRed: Terminal.StyledFragment {
        appendingStyle(background: .red)
    }
    
    /// Returns a copy of the current fragment setting ANSI green as the background color.
    @inline(__always)
    var onGreen: Terminal.StyledFragment {
        appendingStyle(background: .green)
    }
    
    /// Returns a copy of the current fragment setting ANSI yellow as the background color.
    @inline(__always)
    var onYellow: Terminal.StyledFragment {
        appendingStyle(background: .yellow)
    }
    
    /// Returns a copy of the current fragment setting ANSI blue as the background color.
    @inline(__always)
    var onBlue: Terminal.StyledFragment {
        appendingStyle(background: .blue)
    }
    
    /// Returns a copy of the current fragment setting ANSI magenta as the background color.
    @inline(__always)
    var onMagenta: Terminal.StyledFragment {
        appendingStyle(background: .magenta)
    }
    
    /// Returns a copy of the current fragment setting ANSI cyan as the background color.
    @inline(__always)
    var onCyan: Terminal.StyledFragment {
        appendingStyle(background: .cyan)
    }
    
    /// Returns a copy of the current fragment setting ANSI bright white as the background color.
    ///
    /// This color usually matches the terminal foreground. In light themes, it may be replaced with one closer to black.
    ///
    /// If you're planning to invert the colors of your text, prefer to use the `invertedLayers` effect instead via the method with same name.
    @inline(__always)
    var onWhite: Terminal.StyledFragment {
        appendingStyle(background: .white)
    }
    
    /// Returns a copy of the current fragment setting ANSI bright black as the background color.
    @inline(__always)
    var onGray: Terminal.StyledFragment {
        appendingStyle(background: .gray)
    }
    
    /// Returns a copy of the current fragment setting the ANSI color provided as the background color.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the modified copy.
    @inline(__always)
    func onANSI(_ color: Terminal.ANSIColor) -> Terminal.StyledFragment {
        appendingStyle(background: .ansi(color))
    }

    /// Returns a copy of the current fragment setting the sRGB color provided as the background color.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the modified copy.
    @inline(__always)
    func onSRGB(_ color: Terminal.SRGBColor) -> Terminal.StyledFragment {
        appendingStyle(background: .srgb(color))
    }
    
    /// Returns a copy of the current fragment setting the sRGB color created from the components provided as the background color.
    ///
    /// - Parameter red: the red component.
    /// - Parameter green: the green component.
    /// - Parameter blue: the blue component.
    /// - Returns: the modified copy.
    @inline(__always)
    func onSRGB(red: Terminal.SRGBColor.Component, green: Terminal.SRGBColor.Component, blue: Terminal.SRGBColor.Component) -> Terminal.StyledFragment {
        appendingStyle(background: .srgb(.init(red: red, green: green, blue: blue)))
    }

    /// Returns a copy of the current fragment setting a color in a text layer.
    ///
    /// - Parameter color: the color to be applied.
    /// - Parameter layer: the layer to be affected.
    /// - Returns: the modified copy.
    @inline(__always)
    func color(_ color: Terminal.Color, at layer: Terminal.Layer) -> Terminal.StyledFragment {
        switch layer {
        case .foreground:
            appendingStyle(foreground: color)
        case .background:
            appendingStyle(background: color)
        }
    }
    
    /// Returns a copy of the current fragment setting bold as the font weight.
    @inline(__always)
    var bold: Terminal.StyledFragment {
        appendingStyle(weight: .bold)
    }
    
    /// Returns a copy of the current fragment setting dim as the font weight.
    @inline(__always)
    var dim: Terminal.StyledFragment {
        appendingStyle(weight: .dim)
    }

    /// Returns a copy of the current fragment setting the font weight provided.
    ///
    /// - Parameter weight: the weight to be applied.
    /// - Returns: the modified copy.
    @inline(__always)
    func weight(_ weight: Terminal.Weight) -> Terminal.StyledFragment {
        appendingStyle(weight: weight)
    }
    
    /// Returns a copy of the current fragment setting italic as an active effect.
    @inline(__always)
    var italic: Terminal.StyledFragment {
        appendingStyle(effects: [.italic])
    }
    
    /// Returns a copy of the current fragment setting underline as an active effect.
    @inline(__always)
    var underline: Terminal.StyledFragment {
        appendingStyle(effects: [.underline])
    }
    
    /// Returns a copy of the current fragment setting blinking as an active effect.
    @inline(__always)
    var blinking: Terminal.StyledFragment {
        appendingStyle(effects: [.blinking])
    }
    
    /// Returns a copy of the current fragment setting inverted layers as an active effect.
    @inline(__always)
    var invertedLayers: Terminal.StyledFragment {
        appendingStyle(effects: [.invertedLayers])
    }
    
    /// Returns a copy of the current fragment setting strikethrough as an active effect.
    @inline(__always)
    var strikethrough: Terminal.StyledFragment {
        appendingStyle(effects: [.strikethrough])
    }
    
    /// Returns a copy of the current fragment setting the effects provided as active.
    ///
    /// - Parameter effects: the effects to be activated.
    /// - Returns: the modified copy.
    @inline(__always)
    func effects(_ effects: Terminal.Effect...) -> Terminal.StyledFragment {
        appendingStyle(effects: Set(effects))
    }
    
    /// Returns a copy of the current fragment setting the padding provided.
    ///
    /// - Parameter padding: the padding to be used.
    /// - Returns: the modified copy.
    @inline(__always)
    func pad(using padding: Terminal.Padding) -> Terminal.StyledFragment {
        appendingStyle(padding: padding)
    }
    
    /// Returns a copy of the current fragment setting the padding created from the components provided.
    ///
    /// - Parameter alignment: the alignment for the text being padded.
    /// - Parameter character: the character to pad with.
    /// - Parameter length: the length for the padding, including the text area.
    /// - Returns: the modified copy.
    @inline(__always)
    func pad(_ alignment: Terminal.Alignment, with character: Character = " ", by length: Terminal.Size) -> Terminal.StyledFragment {
        appendingStyle(padding: .init(alignment, with: character, by: length))
    }
    
    /// Returns a copy of the current fragment setting the style provided.
    ///
    /// - Parameter style: the style to be applied.
    /// - Returns: the modified copy.
    @inline(__always)
    func style(_ style: Terminal.Style) -> Terminal.StyledFragment {
        .init(string, style: style)
    }
}

public extension String {
    @inline(__always)
    fileprivate func rawPad(using padding: Terminal.Padding) -> String {
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
    
    /// Creates a styled fragment from the current string setting ANSI black as the foreground color.
    ///
    /// This color usually matches the terminal background. In light themes, it may be replaced with one closer to white.
    @inline(__always)
    var black: Terminal.StyledFragment {
        .init(self, style: .init(foreground: .black))
    }
    
    /// Creates a styled fragment from the current string setting ANSI red as the foreground color.
    @inline(__always)
    var red: Terminal.StyledFragment {
        .init(self, style: .init(foreground: .red))
    }
    
    /// Creates a styled fragment from the current string setting ANSI green as the foreground color.
    @inline(__always)
    var green: Terminal.StyledFragment {
        .init(self, style: .init(foreground: .green))
    }
    
    /// Creates a styled fragment from the current string setting ANSI yellow as the foreground color.
    @inline(__always)
    var yellow: Terminal.StyledFragment {
        .init(self, style: .init(foreground: .yellow))
    }
    
    /// Creates a styled fragment from the current string setting ANSI blue as the foreground color.
    @inline(__always)
    var blue: Terminal.StyledFragment {
        .init(self, style: .init(foreground: .blue))
    }
    
    /// Creates a styled fragment from the current string setting ANSI magenta as the foreground color.
    @inline(__always)
    var magenta: Terminal.StyledFragment {
        .init(self, style: .init(foreground: .magenta))
    }
    
    /// Creates a styled fragment from the current string setting ANSI cyan as the foreground color.
    @inline(__always)
    var cyan: Terminal.StyledFragment {
        .init(self, style: .init(foreground: .cyan))
    }
    
    /// Creates a styled fragment from the current string setting ANSI bright white as the foreground color.
    ///
    /// This color usually matches the terminal foreground. In light themes, it may be replaced with one closer to black.
    @inline(__always)
    var white: Terminal.StyledFragment {
        .init(self, style: .init(foreground: .white))
    }
    
    /// Creates a styled fragment from the current string setting ANSI bright black as the foreground color.
    ///
    /// This color is usually a darker shade of the terminal foreground, useful for captions.
    @inline(__always)
    var gray: Terminal.StyledFragment {
        .init(self, style: .init(foreground: .gray))
    }
    
    /// Creates a styled fragment from the current string setting the ANSI color provided as the foreground color.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the fragment.
    @inline(__always)
    func ansi(_ color: Terminal.ANSIColor) -> Terminal.StyledFragment {
        .init(self, style: .init(foreground: .ansi(color)))
    }
    
    /// Creates a styled fragment from the current string setting the sRGB color provided as the foreground color.
    ///
    /// - Parameter color: the color to be applied.
    /// - Returns: the fragment.
    @inline(__always)
    func srgb(_ color: Terminal.SRGBColor) -> Terminal.StyledFragment {
        .init(self, style: .init(foreground: .srgb(color)))
    }

    /// Creates a styled fragment from the current string setting the sRGB color created from the components provided as the foreground color.
    ///
    /// - Parameter red: the red component.
    /// - Parameter green: the green component.
    /// - Parameter blue: the blue component.
    /// - Returns: the fragment.
    @inline(__always)
    func srgb(red: Terminal.SRGBColor.Component, green: Terminal.SRGBColor.Component, blue: Terminal.SRGBColor.Component) -> Terminal.StyledFragment {
        .init(self, style: .init(foreground: .srgb(.init(red: red, green: green, blue: blue))))
    }
    
    /// Creates a styled fragment from the current string setting ANSI red as the background color.
    @inline(__always)
    var onRed: Terminal.StyledFragment {
        .init(self, style: .init(background: .red))
    }
    
    /// Creates a styled fragment from the current string setting ANSI green as the background color.
    @inline(__always)
    var onGreen: Terminal.StyledFragment {
        .init(self, style: .init(background: .green))
    }
    
    /// Creates a styled fragment from the current string setting ANSI yellow as the background color.
    @inline(__always)
    var onYellow: Terminal.StyledFragment {
        .init(self, style: .init(background: .yellow))
    }
    
    /// Creates a styled fragment from the current string setting ANSI blue as the background color.
    @inline(__always)
    var onBlue: Terminal.StyledFragment {
        .init(self, style: .init(background: .blue))
    }
    
    /// Creates a styled fragment from the current string setting ANSI magenta as the background color.
    @inline(__always)
    var onMagenta: Terminal.StyledFragment {
        .init(self, style: .init(background: .magenta))
    }
    
    /// Creates a styled fragment from the current string setting ANSI cyan as the background color.
    @inline(__always)
    var onCyan: Terminal.StyledFragment {
        .init(self, style: .init(background: .cyan))
    }
    
    /// Creates a styled fragment from the current string setting ANSI bright white as the background color.
    ///
    /// This color usually matches the terminal foreground. In light themes, it may be replaced with one closer to black.
    @inline(__always)
    var onWhite: Terminal.StyledFragment {
        .init(self, style: .init(background: .white))
    }
    
    /// Creates a styled fragment from the current string setting ANSI bright black as the background color.
    @inline(__always)
    var onGray: Terminal.StyledFragment {
        .init(self, style: .init(background: .gray))
    }
    
    /// Creates a styled fragment from the current string setting the ANSI color provided as the background color.
    ///
    /// - Returns: the fragment.
    @inline(__always)
    func onANSI(_ color: Terminal.ANSIColor) -> Terminal.StyledFragment {
        .init(self, style: .init(background: .ansi(color)))
    }

    /// Creates a styled fragment from the current string setting the sRGB color provided as the background color.
    ///
    /// - Returns: the fragment.
    @inline(__always)
    func onSRGB(_ color: Terminal.SRGBColor) -> Terminal.StyledFragment {
        .init(self, style: .init(background: .srgb(color)))
    }
    
    /// Creates a styled fragment from the current string setting the sRGB color created from the components provided as the background color.
    ///
    /// - Returns: the fragment.
    @inline(__always)
    func onSRGB(red: Terminal.SRGBColor.Component, green: Terminal.SRGBColor.Component, blue: Terminal.SRGBColor.Component) -> Terminal.StyledFragment {
        .init(self, style: .init(background: .srgb(.init(red: red, green: green, blue: blue))))
    }

    /// Creates a styled fragment from the current string setting a color in a text layer.
    ///
    /// - Parameter color: the color to be applied.
    /// - Parameter layer: the layer to be affected.
    /// - Returns: the fragment.
    @inline(__always)
    func color(_ color: Terminal.Color, at layer: Terminal.Layer) -> Terminal.StyledFragment {
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
    @inline(__always)
    var bold: Terminal.StyledFragment {
        .init(self, style: .init(weight: .bold))
    }
    
    /// Creates a styled fragment from the current string setting dim as the font weight.
    @inline(__always)
    var dim: Terminal.StyledFragment {
        .init(self, style: .init(weight: .dim))
    }

    /// Creates a styled fragment from the current string setting the font weight provided.
    ///
    /// - Parameter weight: the weight to be applied.
    /// - Returns: the fragment.
    @inline(__always)
    func weight(_ weight: Terminal.Weight) -> Terminal.StyledFragment {
        .init(self, style: .init(weight: weight))
    }
    
    /// Creates a styled fragment from the current string setting italic as an active effect.
    @inline(__always)
    var italic: Terminal.StyledFragment {
        .init(self, style: .init(effects: [.italic]))
    }
    
    /// Creates a styled fragment from the current string setting underline as an active effect.
    @inline(__always)
    var underline: Terminal.StyledFragment {
        .init(self, style: .init(effects: [.underline]))
    }
    
    /// Creates a styled fragment from the current string setting blinking as an active effect.
    @inline(__always)
    var blinking: Terminal.StyledFragment {
        .init(self, style: .init(effects: [.blinking]))
    }
    
    /// Creates a styled fragment from the current string setting inverted layers as an active effect.
    @inline(__always)
    var invertedLayers: Terminal.StyledFragment {
        .init(self, style: .init(effects: [.invertedLayers]))
    }
    
    /// Creates a styled fragment from the current string setting strikethrough as an active effect.
    @inline(__always)
    var strikethrough: Terminal.StyledFragment {
        .init(self, style: .init(effects: [.strikethrough]))
    }
    
    /// Creates a styled fragment from the current string setting the effects provided as active.
    ///
    /// - Parameter effects: the effects to be activated.
    /// - Returns: the fragment.
    @inline(__always)
    func effects(_ effects: Terminal.Effect...) -> Terminal.StyledFragment {
        .init(self, style: .init(effects: Set(effects)))
    }
    
    /// Creates a styled fragment from the current string setting the padding provided.
    ///
    /// - Parameter padding: the padding to be used.
    /// - Returns: the modified copy.
    @inline(__always)
    func pad(using padding: Terminal.Padding) -> Terminal.StyledFragment {
        .init(self, style: .init(padding: padding))
    }
    
    /// Creates a styled fragment from the current string setting the padding created from the components provided.
    ///
    /// - Parameter alignment: the alignment for the text being padded.
    /// - Parameter character: the character to pad with.
    /// - Parameter length: the length for the padding, including the text area.
    /// - Returns: the fragment.
    @inline(__always)
    func pad(_ alignment: Terminal.Alignment, with character: Character = " ", by length: Terminal.Size) -> Terminal.StyledFragment {
        .init(self, style: .init(padding: .init(alignment, with: character, by: length)))
    }

    /// Creates a styled fragment from the current string setting the style provided.
    ///
    /// - Parameter style: the style to be applied.
    /// - Returns: the fragment.
    @inline(__always)
    func style(_ style: Terminal.Style) -> Terminal.StyledFragment {
        .init(self, style: style)
    }
}

@inline(__always)
public func +(lhs: Terminal.StyledFragment, rhs: Terminal.StyledFragment) -> Terminal.StyledString {
    "\(lhs)\(rhs)"
}

@inline(__always)
public func +(lhs: Terminal.StyledFragment, rhs: Terminal.StyledString) -> Terminal.StyledString {
    "\(lhs)\(rhs)"
}

@inline(__always)
public func +(lhs: Terminal.StyledString, rhs: Terminal.StyledFragment) -> Terminal.StyledString {
    "\(lhs)\(rhs)"
}

@inline(__always)
public func +(lhs: Terminal.StyledString, rhs: Terminal.StyledString) -> Terminal.StyledString {
    "\(lhs)\(rhs)"
}
