# Teco (Terminal Control Operations)
<img alt="" src="Assets/FrameworkIcon.png" width="90" />

## About
A playful Swift 6.2 terminal manipulation toolkit for building command-line tools for macOS 14 (Sonoma) or later.

## Install
### Swift Package Manager
- Ensure your package supports, at least, the macOS 14 (Sonoma) platform:

```swift
platforms: [
    .macOS(.v14)
]
```

- Add it to your package dependencies:

```swift
dependencies: [
    .package(
        url: "https://github.com/skippyr/Teco",
        from: "1.0.0"
    )
]
```

- Make the desired targets depend on it:

```swift
.executableTarget(
    name: "YourApp",
    dependencies: ["Teco"]
)
```

### Xcode Project
- Open your target settings.
- Ensure your target has, at least, macOS 14 (Sonoma) as the minimum deployment version.
- Click on the `+` button under the `General > Frameworks and Libraries` section.
- Use the `Add Other...` dropdown menu at the bottom left corner, selecting the `Add Package Dependency...` option.
- Use the `Search or Enter Package URL` search bar at the top right corner to search for the `https://github.com/skippyr/Teco` repository.
- Select the `teco` package in the result list and click on the `Add Package` button at the bottom right corner.
- Choose the desired targets to be using it and click on the `Add Package` button again.
- For the best experience, if possible, ensure your project uses `Swift 6` as the language version under its `Build Settings`.

## Usage
This section will give you an overview about the library. For more details, refer to the documentation of its components on Xcode.

> [!IMPORTANT]
> Whenever you're using this library, debug your software using the Terminal app instead of Xcode, because its embedded console doesn't support any of the added features.
>
> Also ensure its profiles declares the terminal as `xterm-256color` under its settings, at `Profiles > Advanced > Terminfo > Declare terminal as:`.


### Import
In order to start using it, you must import the `Teco` module at the top of your Swift files:

```swift
import Teco
```

It automatically exports the Foundation framework.

### Thread Safety
The primary component introduced into scope is the `Terminal` enum, which is as a handler for manipulating the emulated terminal. To ensure thread safety for building TUI and accessing its cached contents, you can only use it within the main actor concurrency domain—the main thread.

Take advantage of modern annotations such as `@main` and `@MainActor` in your software to make it thread safer and be able to use the library without too much ceremony.

All examples in this documentation are implicitly within that domain.

### Streams
#### Printing
Use the `Terminal.print` method to write to a writable stream—standard output (by default) or standard error (if specified). In this context, it behaves similarly to the standard Swift `print` function, but it's also capable of applying the styles embedded in your strings, automatically removing them—except padding—from the output if the stream is redirected.

```swift
Terminal.print("(output) Here Be Dragons!".blue)
Terminal.print("(error) Here Be Dragons!".red, via: .error)
```

The styling behavior is further influenced by the booleans `Terminal.shouldApplyColors` and `Terminal.shouldApplyStyles`. Modify these variables to implement custom behavior in your software, for example, to allow your user to set its preferences using options.

```swift
for argument in CommandLine.arguments
  .dropFirst()
  .map({ $0.trimmingCharacters(in: .newlines) }) {
    if argument == "--no-color" {
        Terminal.shouldApplyColors = false
        continue
    } else if argument == "--no-ansi" {
        Terminal.shouldApplyStyles = false
        continue
    }
}
```

#### Redirections
The `Terminal` enum caches whether the streams are being redirected. Check it to ensure your software has the appropriate environment for it to run.

```swift
guard !Terminal.isInputRedirected else {
    throwError("the input stream cannot be redirected.")
}
```

```swift
guard !Terminal.isOutputRedirected && !Terminal.isErrorRedirected else {
    throwError("the output streams cannot be redirected.")
}
```

#### Buffers
If necessary, for example, when writing in a loop without outputing the newline sequence, you can use the `Terminal.flushOutputBuffer()` method to flush the terminal output stream buffer contents:

```swift
Terminal.flushOutputBuffer()
```

### Styles
#### Types
The library adds three new types you need to learn to handle styles:
- `TextStyle`: contains the style properties a text might have.
- `StyledTextFragment`: associates a string with a text style.
- `StyledText`: glues styled fragments together in order to make a full text, possibly with mixed styles.


Styles can affect text properties such as foreground and background colors, effects, padding, and font weight. They can be stored in variables and applied to any type that implements the `CustomStringConvertible` protocol using the `style` method, or you can configure each property individually through more specific extensions. Internally, they wrap their string description.

```swift
let customStyle = TextStyle(foreground: .blue)
Terminal.print("Here Be Dragons!".style(customStyle))
Terminal.print(10.red.bold.underline, via: .error)
```

Note that most common way of creating styled fragments and styled texts is by using extensions and string interpolation, respectively:

```swift
let styledFragment = "Dragons!".yellow
let styledText: StyledText = "\("Here".red) \("Be".onGreen.bold) \(styledFragment)!"
```

`StyledText` implement a custom string interpolation parsing algorithm that splits a text into a list of `StyledTextFragment`, stored internally. Therefore, in the example above, the `styledText` variable ends up composed by 6 fragments:
1. `"Here"` with ANSI red foreground.
1. `" "` with blank style.
1. `"Be"` with ANSI green background and bold effect.
1. `" "` with blank style.
1. `"Dragons"` (from the `styledFragment` variable) with ANSI yellow foreground.
1. `!` with blank style.

> [!CAUTION]
> Nesting styles within string interpolations is possible, but is error prone, because, without type hints, Swift will cast your string literals to `String` instead of `StyledText`.

`StyledText` is the perfect type to pass as function parameters. Convert styled fragments and strings to it using its initalizer. String literals can be automatically converted if that type is made explicit or implicitly deductible by the context.

```swift
@MainActor
static func throwError(_ message: StyledText) -> Never {
    Terminal.print("\("error:".red.bold) \(message)", via: .error)
    exit(EXIT_FAILURE)
}
```

```swift
let styledFragment = "Dragons".red.bold
let string = "Here Be Dragons!"
let styledTextFromFragment = StyledText(styledFragment)
let styledTextFromString = StyledText(string)
let styledTextFromLiteral: StyledText = "Here Be Dragons!"
```

Strings can also be converted to styled fragments via its initalizer, though this is usually unecessary. When not using extension methods, the resulting fragments have blank styles. Internally, styled text invoke it when handling the interpolations of strings and literals.

Use the `string` computed property to access the underlying text of a styled fragment or styled text. Fragments return the string they are wrapping, while styled texts concatenate the text of their fragments. If you just need the length of the string, prefer to use `count`—as it avoid heap allocations:

```swift
let message = "Here Be Dragons!".red.bold
Terminal.print(
    """
    Total Characters: \(message.count)
    Has Dragons: \(message.string.contains("Dragons")).
    """
)
```

#### Colors
The library supports setting colors of the ANSI-256 color palette and RGB colors within the sRGB color profile as the text foreground and background colors. These color formats are contained within the `Color` enum.

An `ANSIColor` is a typealias for an `UInt8` value. The first 16 colors of this palette are defined by the terminal theme and have names. The most common ones are implemented as static values in the `Color` enum:
- `.black`: the ANSI black color (same as `.ansi(0)`).
- `.red`: the ANSI red color (same as `.ansi(1)`).
- `.green`: the ANSI green color (same as `.ansi(2)`).
- `.yellow`: the ANSI yellow color (same as `.ansi(3)`).
- `.blue`: the ANSI blue color (same as `.ansi(4)`).
- `.magenta`: the ANSI magenta color (same as `.ansi(5)`).
- `.cyan`: the ANSI cyan color (same as `.ansi(6)`).
- `.white`: the ANSI bright white color (same as `.ansi(15)`).
- `.gray`: the ANSI bright black color (same as `.ansi(8)`).

An `SRGBColor` color contains the RGB components of a color defined within the sRGB color space, and it can be created using its initalizer. You can even use the `#colorLiteral` macro to have access to a color palette on Xcode/VSCode:

```swift
let yellow = SRGBColor(red: 255, green: 255, blue: 0)
let red = SRGBColor(hex: 0xff0000)!
let purple = SRGBColor(#colorLiteral(/* (...) */))!
```

Apply colors using the extension methods `ansi`, `onANSI`, `sRGB`, `onSRGB`, `color` or one with the name of an ANSI color previously mentioned. The prefix `on` is used for methods that apply to the background.

```swift
let text = "Here Be Dragons!"
Terminal.print(
    """
    \(text.red) \(text.onRed)
    \(text.color(.sRGB(yellow), at: .foreground))
    """
)
```

#### Text Weights
This feature historically controls the text brightness/color intensity, but most modern terminals now make it also affect the font weight. The `TextWeight` enum defines the available weight options. You can adjust the appearance of your text by using the `bold` and `dim` computed properties or the `weight` method:

```swift
Terminal.print(
    """
    \(text.bold)
    \(text.weight(.dim))
    """
)
```

The bold weight may be rendered with bold font and/or bright colors, and the dim weight makes the colors of your text faint.

#### Text Effects
Make your text fancier using effects. Available effects—the most supported ones—are containined within the `TextEffect` enum:
- `italic`: makes the text use italic font.
- `underline`: draws a horizontal line below the text.
- `blink`: makes the text blink in slow pace.
- `swapLayers`: swaps the foreground and background layers, affecting where colors are applied.
- `strikethrough`: draws a horizontal line through the text.

Apply styles using the `effects` method or computed properties that match the names listed above:

```swift
let customEffects: Set<TextEffect> = [.italic, .underline]
let text = "Here Be Dragons!"
Terminal.print(
    """
    \(text.swapLayers)
    \(text.effects(customEffects))
    """
)
```

#### Padding
Align texts in your TUIs using the `padding` method, specifying the alignment for the text, the character to pad with, and how much cells to have filled, including your text area:

```swift
let customPadding = TextPadding(align: .left, upTo: 80)
let text = "Here Be Dragons!"
Terminal.print(
    """
    \(text.onMagenta.padding(align: .center, upTo: 80))
    \(text.onYellow.padding(customPadding))
    \(text.onBlue.padding(align: .right, with: "-", upTo: 80))
    """
)
```

## Cursor
### Appearance
Change the terminal cursor shape and visibility using the `Terminal.withCursor` method. It maintains an internal stack to track all applied cursor states, allowing nested changes and ensuring that each scope automatically restores the previous appearance when it ends.

In order for the new cursor appearance to be seen, the operation following its set must last long enough, such as to wait for user input or to await for resources to become ready:

```swift
Terminal.print("Press \("[Enter]".yellow) to advance the steps:")
Terminal.withCursor(.verticalBar, blink: false) {
    Terminal.print("Steady Vertical Bar ", terminator: "")
    _ = readLine()
    Terminal.withCursor(visible: false) {
        Terminal.print("Invisible ", terminator: "")
        _ = readLine()
    }
    Terminal.print("Steady Vertical Bar ", terminator: "")
    _ = readLine()
}
```

## Screen
### Dimensions
The dimensions of the terminal screen can be retrieved for building TUIs that adapt to the available space or ensuring your software has the space it needs to run:

```swift
guard let dimensions = try? Terminal.screenDimensions else {
    throwError("cannot retrieve the dimensions of the terminal screen.")
}
guard dimensions >= 80 else {
    throwError("the terminal screen needs to have, at least, 80 columns.")
}
Terminal.print(
    """
    Total Columns: \(dimensions.totalColumns)
    Total Rows: \(dimensions.totalRows)
    """
)
```

### Alternate Buffer
The alternate screen buffer is a separate screen environment your app can use to keep the history and state of the primary one intact. Execute code in the alternate buffer by putting it within the scope of `Terminal.withAlternateScreen(action:)`.

In order for the alternate screen to be seen, the operation performed must last long enough, such as to wait for user input or to await for resources to become ready:

```swift
try Terminal.withAlternateScreen {
    Terminal.print(
        """
        Here Be Dragons!
        Press \("[Return]".yellow) to exit.
        """
    )
    _ = readLine()
}
```

## Clearing
Clear a specific region of the terminal—either the entire screen (`.screen`) or just the current line (`.line`)—to refresh the views in your TUIs. Each region defines a corresponding cursor restore position which gets set after clearing.

```swift
try Terminal.clear() // same as Terminal.clear(.screen)
try Terminal.clear(.screen)
try Terminal.clear(.line)
```

## Bell
Ring the terminal bell using the `Terminal.ringBell()` method, possibly making the terminal dock icon bounce, emit the alert sound, show a symbol in the interface, and/or flash the screen.

```swift
Terminal.ringBell()
```

## Support
If you need help with this project, you can [open a new issue](https://github.com/skippyr/Teco/issues/new) or [send an email](mailto:skippyr.developer@icloud.com) describing the problem in detail.

## Contributing
Feel free to share suggestions or propose solutions that could help improve this project. If something catches your interest, you're welcome to open a new issue or contribute to an existing one via its [issues page](https://github.com/skippyr/Teco/issues).

## Copyright
This software is distributed under the MIT License. For complete terms, see the accompanying `LICENSE` file included in the source code. When applicable, a `NOTICE` file may also be provided to acknowledge copyrights or other attributions for third-party components.
