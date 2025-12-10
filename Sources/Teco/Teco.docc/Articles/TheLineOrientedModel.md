# Building line-oriented apps
Learn how to pretty print, parse arguments, and ensure the proper environment for your apps to run.
@Metadata {
  @PageKind(sampleCode)
}

## Overview
Line-oriented applications are recognized for their simplicity, straightforward approach, and effortless integration with other tools. Their reliability has kept them at the core of many workflows for decades.

In this article, you'll learn how to create your first terminal applications in this enduring tradition.

## Import
Start by importing the Teco framework at the top of your Swift files:

```swift
import Teco
```

It forwards the Foundation framework for the basic needs of your apps.

> Warning:
> Teco framework takes ownership of terminal I/O and state management. Mixing it with other terminal-related frameworks can invalidate its internal caches, desynchronize streams, and corrupt output.

## Thread safety
Many features introduced by the framework—particularly those that manipulate the terminal—are restricted to the main thread because they rely on a single, serialized execution context for consistent state management and TUI rendering.

Use Swift attributes such as `@main` and `@MainActor` to ensure your code executes within this required concurrency domain.

> All code throughout the rest of this article may be implicitly within that domain.

## Pretty printing
Use the `Terminal.print` method to write to the terminal. Specify a ``WritableStream`` using the `via` label. If unspecified, it considers the standard output stream (``WritableStream/output``).

```swift
Terminal.print("(stdout) Here Be Dragons!")
Terminal.print("(stderr) Here Be Dragons!", via: .error)
```

> Important:
> Xcode's built-in console doesn't support any terminal capability.
>
> Test your app using the Terminal app instead. Make sure the terminal is configured to declare itself as `xterm-256color` under its settings, at **Profiles → Advanced → Terminfo → Declare Terminal as**.
>
> For more advanced use cases, consider using a fully featured terminal emulator such as [Kitty](https://sw.kovidgoyal.net/kitty) and [iTerm2](https://iterm2.com).

### Style types & extensions

Teco extends types that conforms to the `CustomStringConvertible` protocol with additional members to associate their description with a style.

Associating a `String` with a ``TextStyle`` produces a ``StyledTextFragment``. Multiple fragments can then be joined via string interpolation or the addition operator (`+`) to form a ``StyledText``—a text body that may contain mixed styles.

Use `Terminal.print` to write styled output to the terminal.

```swift
Terminal.print("\("Here".red) \("Be".green.underline) \("Dragons!".yellow.bold)")
```

> Warning:
> Nesting styles within string interpolations is possible, but error prone. Without type hints, Swift casts string literals to `String` instead of `StyledText`.

Text styles can affect colors, effects, weight, and padding. They can be saved to variables and reused across your app via the ``Swift/CustomStringConvertible/style(_:)`` method.

```swift
@MainActor let titleStyle = TextStyle(foreground: .magenta, weight: .bold)
@MainActor let optionStyle = TextStyle(foreground: .green)
@MainActor let urlStyle = TextStyle(foreground: .blue, effects: [.underline])
```

```swift
@MainActor
private static func writeHelp() {
    Terminal.print(
        """
        \("Usage:".style(titleStyle)) your-app [\("OPTION".style(optionStyle).underline)]...
        An example software that write help instructions.
        
        \("AVAILABLE OPTIONS".style(titleStyle))
            \("-h".style(optionStyle)), \("--help".style(optionStyle))     shows the software help instructions.
            \("-v".style(optionStyle)), \("--version".style(optionStyle))  shows the software version.
        """
    )
}
```

```swift
@MainActor
private static func writeVersion() {
    Terminal.print(
        """
        \("your-app".style(titleStyle)) \("1.0.0".yellow)
        \("https://github.com/user/your-app".style(urlStyle))
        """
    )
}
```

``StyledText`` is the perfect type to be used for function parameters. Convert instances of `String` and ``StyledTextFragment`` to it using the `init(_:)` initializer. String literals may be automatically converted if the type is made explicit or deductible by the context.

```swift
@MainActor
private static func throwError(_ message: StyledText) -> Never {
    Terminal.print("\("error:".red.bold) \(message)", via: .error)
    exit(EXIT_FAILURE)
}
```

```swift
let string = "Here Be Dragons!"
let styledFragment = "Here Be Dragons!".red
let styledTextFromString = StyledText(string)
let styledTextFromFragment = StyledText(styledFragment)
let styledTextFromLiteral: StyledText = "Here Be Dragons!"
```

You can access the underlying `String` of a ``StyledTextFragment`` or ``StyledText`` at any time via the `string` computed property. When you only need its length, prefer `count`—it avoids heap allocations.

```swift
let text = "\("Here".red) \("Be".green.underline) \("Dragons!".yellow.bold)"
Terminal.print(
    """
    Length: \(message.count)
    Mentions Dragons: \(message.string.contains("Dragons"))
    """
)
```

All styles, except padding, are not applied by the `Terminal.print` method if the stream specified is redirected. Moreover, you can implement custom styling behavior by overwriting the booleans [`Terminal.shouldApplyStyles`](doc:Terminal/shouldApplyStyles) and [`Terminal.shouldApplyColors`](doc:Terminal/shouldApplyColors).

### Colors
Set colors of the ANSI 256-color palette or sRGB color profile on the text foreground and background layers. These color formats and layers are contained within the ``Color`` and ``TextLayer`` enums, respectively.

The ANSI 256-color palette is a standardized color set used by terminals. The first 16 colors are defined by the terminal's theme, which makes them feel more integrated. For this reason, some members of this subset are exposed as static fields on the ``Color`` enum. For the remaining, use the ``Color/ansi(_:)`` initializer. An ``ANSIColor`` is a typealias for `UInt8`.
- [`.black`](doc:Color/black): the ANSI black color (equivalent to [`.ansi(0)`](doc:Color/ansi(_:))).
- [`.red`](doc:Color/red): the ANSI red color (equivalent to [`.ansi(1)`](doc:Color/ansi(_:))).
- [`.green`](doc:Color/green): the ANSI green color (equivalent to [`.ansi(2)`](doc:Color/ansi(_:))).
- [`.yellow`](doc:Color/yellow): the ANSI yellow color (equivalent to [`.ansi(3)`](doc:Color/ansi(_:))).
- [`.blue`](doc:Color/blue): the ANSI blue color (equivalent to [`.ansi(4)`](doc:Color/ansi(_:))).
- [`.magenta`](doc:Color/magenta): the ANSI magenta color (equivalent to [`.ansi(5)`](doc:Color/ansi(_:))).
- [`.cyan`](doc:Color/cyan): the ANSI cyan color (equivalent to [`.ansi(6)`](doc:Color/ansi(_:))).
- [`.white`](doc:Color/white): the ANSI bright white color (equivalent to [`.ansi(15)`](doc:Color/ansi(_:))).
- [`.gray`](doc:Color/gray): the ANSI bright black color (equivalent to [`.ansi(8)`](doc:Color/ansi(_:))).

Set an ANSI color on a layer by using the ``Swift/CustomStringConvertible/ansi(_:)``, ``Swift/CustomStringConvertible/onANSI(_:)``, or ``Swift/CustomStringConvertible/color(_:at:)`` methods, or via computed properties named after the colors listed above.

```swift
Terminal.print("Here Be Dragons!".red)
Terminal.print("Here Be Dragons!".onANSI(20))
Terminal.print("Here Be Dragons!".color(.ansi(30), at: .foreground))
```

> Color extensions prefixed with "on" apply the color to the background, while unprefixed ones apply it to the foreground.

Use ``SRGBColor`` to create RGB colors defined in the sRGB color space. You can initialize a color from individual components, from a hexadecimal value, or via the `#colorLiteral` macro—which provides access to Xcode's built-in color picker. An ``SRGBColor/Component`` is a typealias for `UInt8`.

Set an sRGB color on a layer by using the ``Swift/CustomStringConvertible/srgb(_:)``, ``Swift/CustomStringConvertible/onSRGB(_:)``, or ``Swift/CustomStringConvertible/color(_:at:)`` methods.

```swift
Terminal.print("Here Be Dragons!".srgb(red: 255, green: 0, blue: 0))
Terminal.print("Here Be Dragons!".onSRGB(SRGBColor(#colorLiteral(/* Color Picker */))!))
Terminal.print("Here Be Dragons!".color(.srgb(SRGBColor(hex: 0x0000ff)!), at: .foreground))
```

> Initializing an sRGB color from a hexadecimal value or via the `#colorLiteral` macro may return `nil` if the color provided cannot be represented in the sRGB color space.

``HEXColor`` is a typealias for `UInt32`, the smallest integer type that can represent all hex color values without an alpha channel.

### Weights
Use weights to highlight the importance of certain text fragments. Available weights are declared in the ``TextWeight`` enum.
- [`.bold`](doc:TextWeight/bold): makes the text use bright colors and/or bold font weight.
- [`.dim`](doc:TextWeight/dim): makes the text colors faint.

Apply a weight by using the ``Swift/CustomStringConvertible/weight(_:)`` method or via computed properties named after the weights listed above.

```swift
Terminal.print(
    """
    \("Here Be Dragons!".bold)
    \("Here Be Dragons!".weight(.dim))
    """
)
```

### Effects
Make text fancier by using effects. Available effects are declared in the ``TextEffect`` enum.
- [`.italic`](doc:TextEffect/italic): makes the text use italic font.
- [`.underline`](doc:TextEffect/underline): draws a horizontal line below the text.
- [`.blink`](doc:TextEffect/blink): makes the text blink at a slow pace.
- [`.swapLayers`](doc:TextEffect/swapLayers): swaps the foreground and background layers, affecting where colors are applied.
- [`.strikethrough`](doc:TextEffect/strikethrough): draws a horizontal line through the text.

Apply a `Set<TextEffect>` by using the ``Swift/CustomStringConvertible/effects(_:)-(Set<TextEffect>)`` method or via computed properties named after the effects listed above.

```swift
Terminal.print(
    """
    \("Here Be Dragons!".swapLayers)
    \("Here Be Dragons!".effects([.italic, .underline]))
    """
)
```

> Important:
> Terminal emulators and emulated terminals vary in their support for these effects. If an effect does not appear as expected, try using a different terminal application or configuration.

### Padding
Padding is useful for aligning contents according to a ``TextAlignment``—perfect for headings, tables, and formatting digits. Apply it using the `padding` method.

Size measurements inside of the terminal uses the ``CellUnit`` type, a typealias for `UInt16`.

```swift
let customPadding = TextPadding(align: .left, upTo: 80)
Terminal.print(
    """
    \("Here Be Dragons!".onMagenta.padding(align: .center, upTo: 80))
    \("Here Be Dragons!".onYellow.padding(customPadding))
    \("Here Be Dragons!".onBlue.padding(align: .right, with: "-", upTo: 80))
    """
)
```

## Parsing arguments
Use Swift's `CommandLine.arguments` to access the arguments given to your program at startup. The first argument is usually the relative path to its binary—often ignored. Use optionals for arguments that may be left empty. For example, it's possible to parse options to show you app's help instructions, version, and control styling behavior.

```swift
for argument in CommandLine.arguments.dropFirst() {
    if argument == "-h" || argument == "--help" {
        writeHelp()
        exit(EXIT_SUCCESS)
    } else if argument == "-v" || argument == "--version" {
        writeVersion()
        exit(EXIT_SUCCESS)
    } else if argument == "--no-color" {
        Terminal.shouldApplyColors = false
    }
}
```

## Ensuring proper environment
Standard streams can be redirected to files or piped into other programs. ``Terminal`` tracks whether these streams are redirected. Use the booleans [`Terminal.isInputRedirected`](doc:Terminal/isInputRedirected), [`Terminal.isOutputRedirected`](doc:Terminal/isOutputRedirected), and [`Terminal.isErrorRedirected`](doc:Terminal/isErrorRedirected)￼ to verify that the appropriate streams are connected to the terminal when your app needs to provide interactivity or present visible output.

```swift
// For interactive apps
guard !Terminal.isInputRedirected else {
    throwError("the input stream cannot be redirected.")
}
```

```swift
// For non-interactive apps
guard !Terminal.isOutputRedirected else {
    throwError("the output stream cannot be redirected.")
}
// or
guard !Terminal.isOutputRedirected && !Terminal.isErrorRedirected else {
    throwError("the output streams cannot be redirected.")
}
```
