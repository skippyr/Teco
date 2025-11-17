//
//  Teco.swift
//  Teco
//
//  Created by Sherman Barros on 10/31/25.
//

import Foundation

/// A handle to manipulate the emulated terminal.
@MainActor public enum Terminal {
  /// A boolean that states the terminal input stream is redirected.
  ///
  /// This value is cached and might stale, even though that's very unlikely to happen for most apps.
  public static let isInputRedirected: Bool = { isatty(STDIN_FILENO) == 0 }()
  /// A boolean that states the terminal output stream is redirected.
  ///
  /// This value is cached and might stale, even though that's very unlikely to happen for most apps.
  public static let isOutputRedirected: Bool = { isatty(STDOUT_FILENO) == 0 }()
  /// A boolean that states the terminal error stream is redirected.
  ///
  /// This value is cached and might stale, even though that's very unlikely to happen for most apps.
  public static let isErrorRedirected: Bool = { isatty(STDERR_FILENO) == 0 }()
  /// The emulated terminal identifier in the terminfo database, retrieved from the `TERM` environment variable.
  ///
  /// This value is cached and might stale, even though that's very unlikely to happen.
  ///
  /// If the variable isn't set, it returns the `dumb` identifier—flagging no capabilities are supported.
  ///
  /// Currently, it doesn't check if the identifier found refers to a valid terminfo entry and is useless for most apps. However, it will be crucial for future releases.
  public static let termInfoID: String = {
    if let id = getenv("TERM") { String(cString: id) } else { "dumb" }
  }()
  private static let isDumb = { termInfoID == "dumb" }()
  /// A boolean that states terminal colors should be applied.
  ///
  /// By default, it only becomes `false` if the environment variable `NO_COLOR` is set and isn't an empty string.
  ///
  /// Even if set to `true`, the terminal may still not apply styles if the `shouldApplyStyles` boolean is `false`.
  public static var shouldApplyColors: Bool = {
    if let noColor = getenv("NO_COLOR") { String(cString: noColor).isEmpty } else { true }
  }()
  /// A boolean that states terminal styles should be applied.
  ///
  /// Currently, by default, it only becomes `false` if the terminal terminfo ID is `dumb`—meaning no capabilities are supported. In future releases, this behavior may become more precise based on the capabilities described in its terminfo entry.
  ///
  /// If `false`, this option may suppress the behavior set by the `shouldApplyColors` boolean.
  public static var shouldApplyStyles: Bool = { !isDumb }()

  private static func unsafeWrite(_ string: UnsafePointer<CChar>, via stream: WritableStream) {
    let file =
      switch stream {
      case .output: stdout
      case .error: stderr
      }
    fputs(string, file)
  }

  /// Writes a styled string to a terminal writable stream, applying the styles described in its fragments considering the `shouldApplyStyles` and `shouldApplyColors` booleans and if the stream is redirected.
  ///
  /// - Parameter string: the string to be written.
  /// - Parameter terminator: the sequence to be appended at the end of the output.
  /// - Parameter stream: the stream being targeted.
  public static func print(
    _ string: StyledString, terminator: String = "\n", via stream: WritableStream = .output
  ) {
    let isStreamRedirected =
      switch stream {
      case .output: isOutputRedirected
      case .error: isErrorRedirected
      }
    let stylesCanBeApplied = shouldApplyStyles && !isStreamRedirected
    string.fragments.forEach { fragment in
      if stylesCanBeApplied {
        if shouldApplyColors {
          if let foreground = fragment.style.foreground {
            setColor(foreground, at: .foreground, via: stream)
          }
          if let background = fragment.style.background {
            setColor(background, at: .background, via: stream)
          }
        }
        if let weight = fragment.style.weight { setWeight(weight, via: stream) }
        if let effects = fragment.style.effects { setEffects(effects, via: stream) }
      }
      let message =
        if let padding = fragment.style.padding { fragment.string.rawPad(using: padding) } else {
          fragment.string
        }
      unsafeWrite(message, via: stream)
      if stylesCanBeApplied
        && (fragment.style.foreground != nil || fragment.style.background != nil
          || fragment.style.weight != nil
          || (fragment.style.effects != nil && !fragment.style.effects!.isEmpty))
      {
        resetStyle(via: stream)
      }
    }
    unsafeWrite(terminator, via: stream)
  }

  /// Writes a styled fragment to a terminal writable stream, applying the styles it describes considering the `shouldApplyStyles` and `shouldApplyColors` booleans and if the stream is redirected.
  ///
  /// - Parameter fragment: the fragment to be written.
  /// - Parameter terminator: the sequence to be appended at the end of the output.
  /// - Parameter stream: the stream being targeted.
  public static func print(
    _ fragment: StyledFragment, terminator: String = "\n", via stream: WritableStream = .output
  ) { print(StyledString(fragment), terminator: terminator, via: stream) }

  /// Writes a string to a terminal writable stream.
  ///
  /// - Parameter string: the string to be written.
  /// - Parameter terminator: the sequence to be appended at the end of the output.
  /// - Parameter stream: the stream being targeted.
  @_disfavoredOverload public static func print(
    _ string: String, terminator: String = "\n", via stream: WritableStream = .output
  ) { unsafeWrite(string + terminator, via: stream) }

  /// Writes the description of an `Any` type to a terminal writable stream.
  ///
  /// The description can be changed by implementing the `CustomStringConvertible` protocol.
  ///
  /// - Parameter item: the item whose description is to be written.
  /// - Parameter terminator: the sequence to be appended at the end of the output.
  /// - Parameter stream: the stream being targeted.
  @_disfavoredOverload public static func print(
    _ item: Any, terminator: String = "\n", via stream: WritableStream = .output
  ) { unsafeWrite(String(describing: item) + terminator, via: stream) }

  /// Writes the newline sequence to a terminal writable stream.
  ///
  /// - Parameter stream: the stream being targeted.
  public static func print(via stream: WritableStream = .output) { unsafeWrite("\n", via: stream) }

  private static func setColor(_ color: Color, at layer: Layer, via stream: WritableStream) {
    switch color {
    case .ansi(let ansi): unsafeWrite("\u{1b}[\(layer.rawValue)8;5;\(ansi)m", via: stream)
    case .srgb(let rgb):
      unsafeWrite("\u{1b}[\(layer.rawValue)8;2;\(rgb.red);\(rgb.green);\(rgb.blue)m", via: stream)
    }
  }

  private static func setWeight(_ weight: Weight, via stream: WritableStream) {
    unsafeWrite("\u{1b}[22;\(weight.rawValue)m", via: stream)
  }

  private static func setEffects(_ effects: Set<Effect>, via stream: WritableStream) {
    effects.forEach { unsafeWrite("\u{1b}[\($0.rawValue)m", via: stream) }
  }

  private static func resetStyle(via stream: WritableStream) {
    unsafeWrite("\u{1b}[0m", via: stream)
  }

  /// Retrieves the terminal window dimensions.
  ///
  /// - Throws:
  ///   - `Error.unsupportedFeature`: if the emulated terminal doesn't report its dimensions.
  ///   - `Error.streamRedirection`: if all streams are redirected, thus not connected to the window.
  public static var dimensions: Dimensions {
    get throws {
      guard !isDumb else { throw Error.unsupportedFeature }
      var systemSize = winsize()
      if !isInputRedirected && ioctl(STDIN_FILENO, TIOCGWINSZ, &systemSize) == -1
        && !isOutputRedirected && ioctl(STDOUT_FILENO, TIOCGWINSZ, &systemSize) == -1
        && !isErrorRedirected && ioctl(STDERR_FILENO, TIOCGWINSZ, &systemSize) == -1
      {
        throw Error.streamRedirection
      }
      return Dimensions(totalColumns: systemSize.ws_col, totalRows: systemSize.ws_row)
    }
  }

  /// Contains the possible errors related to terminal manipulation.
  public enum Error: Swift.Error {
    /// The requested feature isn't supported by the emulated terminal.
    case unsupportedFeature
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

    /// A color of the ANSI 256 color palette.
    ///
    /// The first 16 colors of this palette should match the ones defined by the terminal theme. Alternatively, you can refer to some of them by name using static values from this enum.
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

  /// Contains the information required to perform padding.
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
    public init(
      foreground: Color? = nil, background: Color? = nil, weight: Weight? = nil,
      effects: Set<Effect>? = nil, padding: Padding? = nil
    ) {
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
      get { if let padding = style.padding { _string.rawPad(using: padding) } else { _string } }
      set { _string = newValue }
    }

    public var description: String { string }
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
    public var string: String { fragments.map(\.string).joined() }

    public var description: String { string }

    public struct StringInterpolation: StringInterpolationProtocol {
      var fragments: [StyledFragment]

      public init(literalCapacity: Int, interpolationCount: Int) {
        fragments = []
        fragments.reserveCapacity(literalCapacity + interpolationCount)
      }

      public mutating func appendLiteral(_ literal: StringLiteralType) {
        if !literal.isEmpty { fragments.append(.init(literal)) }
      }

      public mutating func appendInterpolation(_ fragment: StyledFragment) {
        if !fragment.string.isEmpty { fragments.append(fragment) }
      }

      public mutating func appendInterpolation(_ string: StyledString) {
        fragments.append(contentsOf: string.fragments.filter { !$0.string.isEmpty })
      }

      public mutating func appendInterpolation(_ value: Any) {
        let string = String(describing: value)
        if !string.isEmpty { fragments.append(.init(string)) }
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
