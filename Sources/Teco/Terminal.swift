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

/// A handler to manipulate the emulated terminal.
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
    private static var ansiPrefersOutput = false
    private static var outputCachesANSI = false
    private static var cursorAppearanceStack: [CursorAppearance] = { [] }()
    private static var isAlternateScreenOpened = false

    private static func streamWrite(_ message: String, via stream: Teco.WritableStream) {
        if stream == .error && !isErrorRedirected && outputCachesANSI {
            flushOutput()
        }
        fputs(message, stream == .output ? stdout : stderr)
        ansiPrefersOutput = stream == .output
    }

    private static func ansiWrite(_ message: String, via stream: Teco.WritableStream?) throws {
        if stream == .output && !isOutputRedirected {
            outputCachesANSI = !message.hasSuffix("\n")
        }
        guard let stream else {
            if ansiPrefersOutput {
                if !isOutputRedirected {
                    streamWrite(message, via: .output)
                } else if !isErrorRedirected {
                    streamWrite(message, via: .error)
                } else {
                    throw Error.streamRedirection
                }
            } else {
                if !isErrorRedirected {
                    streamWrite(message, via: .error)
                } else if !isOutputRedirected {
                    streamWrite(message, via: .output)
                } else {
                    throw Error.streamRedirection
                }
            }
            return
        }
        if stream == .output ? isOutputRedirected : isErrorRedirected {
            throw Error.streamRedirection
        }
        streamWrite(message, via: stream)
    }

    /// Flushes the terminal output stream buffer, writing all content it might be caching.
    private static func flushOutput() {
        fflush(stdout)
        outputCachesANSI = false
    }

    private static func withRawMode<T>(action: () throws -> T) throws -> T {
        if isInputRedirected {
            throw Error.streamRedirection
        }
        var attributes = termios()
        tcgetattr(STDIN_FILENO, &attributes)
        attributes.c_lflag &= ~(UInt(ICANON) | UInt(ECHO) | UInt(ISIG))
        tcsetattr(STDIN_FILENO, TCSANOW, &attributes)
        defer {
            attributes.c_lflag |= UInt(ICANON) | UInt(ECHO) | UInt(ISIG)
            tcsetattr(STDIN_FILENO, TCSANOW, &attributes)
        }
        let result = try action()
        return result
    }

    /// Clears all the events possibly cached in the terminal input stream buffer.
    private static func clearEventQueue() {
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
                        setTextColor(foreground, at: .foreground, via: stream)
                    }
                    if let background = fragment.style.background {
                        setTextColor(background, at: .background, via: stream)
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

    private static func setTextColor(_ color: Teco.Color, at layer: Teco.TextLayer, via stream: Teco.WritableStream) {
        switch color {
        case .ansi(let ansi):
            try? ansiWrite("\u{1b}[\(layer.ansi)8;5;\(ansi)m", via: stream)
        case .srgb(let sRGB), .sRGB(let sRGB):
            try? ansiWrite("\u{1b}[\(layer.ansi)8;2;\(sRGB.red);\(sRGB.green);\(sRGB.blue)m", via: stream)
        }
    }

    private static func setTextWeight(_ weight: Teco.TextWeight, via stream: Teco.WritableStream) {
        try? ansiWrite("\u{1b}[22;\(weight.ansi)m", via: stream)
    }

    private static func setTextEffects(_ effects: Set<Teco.TextEffect>, via stream: Teco.WritableStream) {
        effects.forEach {
            do {
                try ansiWrite("\u{1b}[\($0.ansi)m", via: stream)
            } catch {
                return
            }
        }
    }

    private static func resetTextStyle(via stream: Teco.WritableStream) {
        try? ansiWrite("\u{1b}[0m", via: stream)
    }

    private static func setCursorVisible(_ visible: Bool) {
        try? ansiWrite("\u{1b}[?25\(visible ? "h" :"l")", via: nil)
    }

    private static func setCursorAppearance(_ appearance: CursorAppearance?) {
        guard let appearance else {
            try? ansiWrite("\u{1b}[0 q", via: nil)
            setCursorVisible(true)
            return
        }
        switch appearance {
        case .withoutShape(let visible):
            setCursorVisible(visible)
        case .withShape(let shape, let visible, let blink):
            try? ansiWrite("\u{1b}[\(shape.ansi(blink: blink)) q", via: nil)
            setCursorVisible(visible)
        }
    }

    private static func withCursor<T>(appearance: CursorAppearance, action: () throws -> T) rethrows -> T {
        cursorAppearanceStack.append(appearance)
        setCursorAppearance(appearance)
        defer {
            _ = cursorAppearanceStack.popLast()
            setCursorAppearance(cursorAppearanceStack.last)
        }
        return try action()
    }

    /// Executes a given closure while temporarily setting the terminal cursor visibility. The visibility is automatically reset at the end of the scope.
    ///
    /// - Parameter visible: a boolean that states the cursor should be visible.
    /// - Parameter action: the closure.
    /// - Returns: any value returned by the closure.
    /// - Throws: it rethrows any error thrown by the closure.
    private static func withCursor<T>(visible: Bool, action: () throws -> T) rethrows -> T {
        let appearance: CursorAppearance =
            if let last = cursorAppearanceStack.last, case .withShape(let shape, _, let blink) = last {
                .withShape(shape: shape, visible: visible, blink: blink)
            } else {
                .withoutShape(visible: visible)
            }
        return try withCursor(appearance: appearance, action: action)
    }

    /// Executes a given closure while temporarily setting the terminal cursor shape. The shape is automatically reset at the end of the scope.
    ///
    /// - Parameter shape: the shape to be applied.
    /// - Parameter blink: a boolean that states the cursor should blink.
    /// - Parameter action: the closure to be executed.
    /// - Returns: any value returned by the closure.
    /// - Throws: it rethrows any error thrown by the closure.
    private static func withCursor<T>(_ shape: CursorShape, blink: Bool = true, action: () throws -> T) rethrows -> T {
        return try withCursor(appearance: .withShape(shape: shape, visible: true, blink: blink), action: action)
    }

    /// Moves the cursor to the given coordinate.
    ///
    /// - Parameter coordinate: the coordinate.
    /// - Throws:
    ///   - `Terminal.Error.unsupportedFeature`: if the emulated terminal doesn't support setting the cursor position.
    ///   - `Terminal.Error.streamRedirection`: if all writable streams are redirected, not allowing the write of the required ANSI sequences.
    ///   - `Terminal.Error.outOfBounds`: if the coordinate provided is outside of the screen boundaries.
    private static func moveCursor(to coordinate: Coordinate) throws {
        guard !isDumb else {
            throw Error.unsupportedFeature
        }
        let screenDimensions = try Terminal.screenDimensions
        guard coordinate.column < screenDimensions.totalColumns && coordinate.row < screenDimensions.totalRows else {
            throw Error.outOfBounds
        }
        try ansiWrite("\u{1b}[\(coordinate.row.saturatedAdd(to: 1));\(coordinate.column.saturatedAdd(to: 1))H", via: nil)
    }

    @available(*, deprecated, renamed: "screenDimensions")
    public static var dimensions: Teco.Dimensions {
        get throws { try screenDimensions }
    }

    /// Retrieves the terminal screen dimensions.
    ///
    /// - Throws:
    ///   - `Terminal.Error.unsupportedFeature`: if the emulated terminal doesn't report its dimensions.
    ///   - `Terminal.Error.streamRedirection`: if all streams are redirected, thus not connected to a screen.
    public static var screenDimensions: Teco.Dimensions {
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

    /// Executes the given closure inside of the terminal alternate screen buffer. The buffer is automatically closed at the end of the scope.
    ///
    /// In order for the alternate screen to be seen, the operation performed must last long enough, such as to wait for user input or to await for resources to become ready.
    ///
    /// - Parameter title: an optional title to set for the screen, which may appear in the title bar or tab bar.
    /// - Parameter action: the closure to be executed.
    /// - Throws:
    ///   - `Terminal.Error.unsupportedFeature`: if the emulated terminal doesn't support the alternate screen feature.
    ///   - `Terminal.Error.streamRedirection`: if all writable streams are redirected, not allowing the write of the required ANSI sequences.
    ///   - `Terminal.Error.alternateScreenInUse`: if the alternate screen is already opened.
    private static func withAlternateScreen<T>(_ title: String? = nil, action: () throws -> T) throws -> T {
        guard !isDumb else {
            throw Error.unsupportedFeature
        }
        guard !isAlternateScreenOpened else {
            throw Error.alternateScreenInUse
        }
        try ansiWrite("\u{1b}[?1049h\u{1b}[2J\u{1b}[H", via: nil)
        if let title {
            try ansiWrite("\u{1b}]0;\(title)\u{7}", via: nil)
        }
        isAlternateScreenOpened = true
        defer {
            try? ansiWrite("\u{1b}[?1049l", via: nil)
            if title != nil {
                try? ansiWrite("\u{1b}]0;\u{7}", via: nil)
            }
            isAlternateScreenOpened = false
        }
        return try action()
    }

    /// Clears a region of the terminal and reset the cursor to its corresponding restore position.
    ///
    /// - Parameter region: the region to be cleared.
    /// - Throws:
    ///   - `Terminal.Error.unsupportedFeature`: if the emulated terminal doesn't support the cleaning feature.
    private static func clear(_ region: CleaningRegion = .screen) throws {
        guard !isDumb else {
            throw Error.unsupportedFeature
        }
        try? ansiWrite(region.ansi, via: nil)
    }

    /// Rings the terminal bell possibly making the terminal dock icon bounce, emit the alert sound, show a symbol in the interface, and/or flash the screen.
    private static func ringBell() {
        try? ansiWrite("\u{7}", via: nil)
    }

    /// Contains the possible errors related to terminal manipulation operations.
    public enum Error: Swift.Error {
        /// Couldn't open the alternate screen, because it's already opened.
        case alternateScreenInUse
        /// An operation failed because a coordinate provided was outside of the terminal screen boundaries.
        case outOfBounds
        /// An operation failed because the requested feature isn't supported by the emulated terminal.
        case unsupportedFeature
        /// A set of redirected streams caused an operation to fail.
        case streamRedirection
    }

    @available(*, deprecated, message: "Use CellUnit defined in the module top-level.")
    public typealias Size = CellUnit
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
