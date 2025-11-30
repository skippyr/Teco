//
//  Terminal.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros <skippyr.developer@icloud.com>
//  Visit my website: https://dragonscave.xyz.
//  Follow me on GitHub: https://github.com/skippyr.
//
//  Refer to the LICENSE file that comes in its source code for more details.
//  If not available, all rights are reserved to the author.
//

/// A handle to manipulate the emulated terminal.
@MainActor
public enum Terminal {
    /// A boolean that states the terminal input stream is being redirected.
    public static let isInputRedirected = { isatty(STDIN_FILENO) == 0 }()
    /// A boolean that states the terminal output stream is being redirected.
    public static let isOutputRedirected = { isatty(STDOUT_FILENO) == 0 }()
    /// A boolean that states the terminal error stream is being redirected.
    public static let isErrorRedirected = { isatty(STDERR_FILENO) == 0 }()
    /// The emulated terminal identifier in the terminfo database.
    public static let termInfoID = {
        if let id = getenv("TERM") {
            String(cString: id)
        } else {
            "dumb"
        }
    }()
    /// A boolean that states colors should be applied in the terminal.
    ///
    /// Defaults to `true` unless the `NO_COLOR` environment variable is set to a non-empty value.
    ///
    /// Styles may still not render if `shouldApplyStyles` is `false`.
    public static var shouldApplyColors = {
        if let noColor = getenv("NO_COLOR") {
            noColor.pointee == 0
        } else {
            true
        }
    }()
    /// A boolean that states styles should be applied in the terminal.
    ///
    /// Defaults to `true` unless the terminal's terminfo ID is `dumb`.
    ///
    /// When `false`, it may override the behavior specified by `shouldApplyColors`.
    public static var shouldApplyStyles = { !isDumb }()
    private static let isDumb = { termInfoID == "dumb" }()

    private static func streamWrite(_ message: String, via stream: Teco.WritableStream) {
        fputs(message, stream == .output ? stdout : stderr)
    }

    /// Writes a styled text to a terminal writable stream, applying the styles described in its fragments considering the booleans `shouldApplyStyles` and `shouldApplyColors` and if the stream is being redirected.
    ///
    /// - Parameter string: the string to be written.
    /// - Parameter terminator: a sequence to be appended at the end of the output.
    /// - Parameter stream: the stream being targeted.
    public static func print(_ string: Teco.StyledText, terminator: String = "\n", via stream: Teco.WritableStream = .output) {
        let isStreamRedirected = stream == .output ? isOutputRedirected : isErrorRedirected
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
                if let weight = fragment.style.weight {
                    setTextWeight(weight, via: stream)
                }
                if let effects = fragment.style.effects {
                    setTextEffects(effects, via: stream)
                }
            }
            let message =
                if let padding = fragment.style.padding {
                    fragment.string.rawPad(using: padding)
                } else {
                    fragment.string
                }
            streamWrite(message, via: stream)
            if stylesCanBeApplied && !fragment.style.isBlank {
                resetTextStyle(via: stream)
            }
        }
        streamWrite(terminator, via: stream)
    }

    /// Writes a styled text fragment to a terminal writable stream, applying the styles it describes considering the booleans `shouldApplyStyles` and `shouldApplyColors` and if the stream is being redirected.
    ///
    /// - Parameter fragment: the fragment to be written.
    /// - Parameter terminator: a sequence to be appended at the end of the output.
    /// - Parameter stream: the stream being targeted.
    public static func print(_ fragment: Teco.StyledTextFragment, terminator: String = "\n", via stream: Teco.WritableStream = .output) {
        print(Teco.StyledText(fragment), terminator: terminator, via: stream)
    }

    /// Writes a string to a terminal writable stream.
    ///
    /// - Parameter string: the string to be written.
    /// - Parameter terminator: a sequence to be appended at the end of the output.
    /// - Parameter stream: the stream being targeted.
    @_disfavoredOverload
    public static func print(_ string: String, terminator: String = "\n", via stream: Teco.WritableStream = .output) {
        streamWrite(string + terminator, via: stream)
    }

    /// Writes the description of an `Any` type to a terminal writable stream.
    ///
    /// - Parameter item: the item whose description is to be written.
    /// - Parameter terminator: a sequence to be appended at the end of the output.
    /// - Parameter stream: the stream being targeted.
    @_disfavoredOverload
    public static func print(_ item: Any, terminator: String = "\n", via stream: Teco.WritableStream = .output) {
        streamWrite(String(describing: item) + terminator, via: stream)
    }

    /// Writes the newline sequence to a terminal writable stream.
    ///
    /// - Parameter stream: the stream being targeted.
    public static func print(via stream: Teco.WritableStream = .output) {
        streamWrite("\n", via: stream)
    }

    private static func setColor(_ color: Teco.Color, at layer: Teco.TextLayer, via stream: Teco.WritableStream) {
        switch color {
        case .ansi(let ansi):
            streamWrite("\u{1b}[\(layer.ansi)8;5;\(ansi)m", via: stream)
        case .srgb(let sRGB), .sRGB(let sRGB):
            streamWrite("\u{1b}[\(layer.ansi)8;2;\(sRGB.red);\(sRGB.green);\(sRGB.blue)m", via: stream)
        }
    }

    private static func setTextWeight(_ weight: Teco.TextWeight, via stream: Teco.WritableStream) {
        streamWrite("\u{1b}[22;\(weight.ansi)m", via: stream)
    }

    private static func setTextEffects(_ effects: Set<Teco.TextEffect>, via stream: Teco.WritableStream) {
        effects.forEach { streamWrite("\u{1b}[\($0.ansi)m", via: stream) }
    }

    private static func resetTextStyle(via stream: Teco.WritableStream) {
        streamWrite("\u{1b}[0m", via: stream)
    }

    /// Retrieves the terminal window dimensions.
    ///
    /// - Throws:
    ///   - `Error.unsupportedFeature`: if the emulated terminal doesn't report its dimensions.
    ///   - `Error.streamRedirection`: if all streams are redirected, thus not connected to the window.
    public static var dimensions: Teco.Dimensions {
        get throws {
            guard !isDumb else {
                throw Error.unsupportedFeature
            }
            var systemSize = winsize()
            if !isInputRedirected && ioctl(STDIN_FILENO, TIOCGWINSZ, &systemSize) == -1 && !isOutputRedirected && ioctl(STDOUT_FILENO, TIOCGWINSZ, &systemSize) == -1 && !isErrorRedirected && ioctl(STDERR_FILENO, TIOCGWINSZ, &systemSize) == -1 {
                throw Error.streamRedirection
            }
            return .init(totalColumns: systemSize.ws_col, totalRows: systemSize.ws_row)
        }
    }

    /// Contains the possible errors related to terminal manipulation operations.
    public enum Error: Swift.Error {
        /// An operation failed because the requested feature isn't supported by the emulated terminal.
        case unsupportedFeature
        /// A set of redirected streams caused an operation to fail.
        case streamRedirection
    }

    /// Represents the unit used for terminal size measurements.
    public typealias Size = UInt16
    @available(*, deprecated, message: "Use WritableStream defined in the module top-level.")
    public typealias WritableStream = Teco.WritableStream
    @available(*, deprecated, message: "Use TextLayer defined in the module top-level.")
    public typealias Layer = TextLayer
    @available(*, deprecated, message: "Use Color defined in the module top-level.")
    public typealias Color = Teco.Color
    @available(*, deprecated, message: "Use ANSIColor defined in the module top-level.")
    public typealias ANSIColor = Teco.ANSIColor
    @available(*, deprecated, message: "Use SRGBColor defined in the module top-level.")
    public typealias SRGBColor = Teco.SRGBColor
    @available(*, deprecated, message: "Use TextWeight defined in the module top-level.")
    public typealias Weight = TextWeight
    @available(*, deprecated, message: "Use TextEffect defined in the module top-level.")
    public typealias Effect = TextEffect
    @available(*, deprecated, message: "Use TextAlignment defined in the module top-level.")
    public typealias Alignment = TextAlignment
    @available(*, deprecated, message: "Use TextPadding defined in the module top-level.")
    public typealias Padding = TextPadding
    @available(*, deprecated, message: "Use TextStyle defined in the module top-level.")
    public typealias Style = TextStyle
    @available(*, deprecated, message: "Use StyledTextFragment defined in the module top-level.")
    public typealias StyledFragment = StyledTextFragment
    @available(*, deprecated, message: "Use StyledText defined in the module top-level.")
    public typealias StyledString = StyledText
    @available(*, deprecated, message: "Use Dimensions defined in the module top-level.")
    public typealias Dimensions = Teco.Dimensions
}
