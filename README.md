# Teco
## About
A Swift terminal manipulation library for building macOS command-line tools. It requires Swift 6.2 and can target macOS 14 Sonoma or later.

Tailored for the ecossystem, where the graphical interface rules, it's perfect for general-purpose tools: those that parse arguments, write styled output with simple TUI, and have minimal user interactions. Intentionally encouraging developers to use SwiftUI for anything beyond that.

## Install
### Swift Package Manager
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


### Import
In order to start using it, you must import the `Teco` module at the top of your Swift files:

```swift
import Teco
```

### Thread Safety
The primary component introduced into scope is the `Terminal` enum, which is as a handle for manipulating the emulated terminal. To ensure thread safety for building TUI and accessing its cached contents, you can only use it within the main actor concurrency domain—the main thread.

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

### Styles
#### Types
The library adds three new types you need to learn to handle styles:
- `TextStyle`: contains the style properties a text might have.
- `StyledTextFragment`: associates a string with a text style.
- `StyledText`: glues styled fragments together in order to make a full text, possibly with mixed styles.


Styles can affect text properties such as foreground and background colors, effects, padding, and font weight. They can be stored in variables and applied to strings using the `style` method, or you can configure each property individually through more specific extensions.

```swift
let customStyle = TextStyle(foreground: .blue)
Terminal.print("Here Be Dragons!".style(customStyle))
Terminal.print("Here Be Dragons!".red.bold.underline, via: .error)
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

`StyledText` is the perfect type to pass as function parameters. Convert styled fragments and strings to it using its constructor. String literals can be automatically converted if that type is made explicit or implicitly deductible by the context.

```swift
@MainActor
static func logError(_ message: StyledText) {
    Terminal.print("\("error:".red.bold) \(message)", via: .error)
}
```

```swift
let styledFragment = "Dragons".red.bold
let string = "Here Be Dragons!"
let styledTextFromFragment = StyledText(styledFragment)
let styledTextFromString = StyledText(string)
let styledTextFromLiteral: StyledText = "Here Be Dragons!"
```

Strings can also be converted to styled fragments via its constructor, though this is usually unecessary. When not using extension methods, the resulting fragments have blank styles. Internally, styled text invoke it when handling the interpolations of strings and literals.

Use the `string` computed property to access the underlying text of a styled fragment or styled text. Fragments return the string they are wrapping, while styled texts concatenate the text of their fragments:

```swift
let message = "Here Be Dragons!".red.bold
Terminal.print("Total Characters: \(message.string.count).")
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

An `SRGBColor` color contains the RGB components of a color defined within the sRGB color space, and it can be created using its constructor:

```swift
let yellow = SRGBColor(red: 255, green: 255, blue: 0)
```

Apply colors using the extension methods `ansi`, `onANSI`, `sRGB`, `onSRGB`, `color` or one with the name of an ANSI color previously mentioned. The prefix `on` is used for methods that apply to the background.

```swift
let text = "Here Be Dragons!"
Terminal.print(
    """
    \(text.red) \(text.onRed)
    \(text.color(.srgb(yellow), at: .foreground))
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
- `blinking`: makes the text blink in slow pace.
- `invertedLayers`: inverts the colors used on the foreground and background layers.
- `strikethrough`: draws a horizontal line through the text.

Apply styles using the `effects` method or computed properties that match the names listed above:

```swift
let customEffects: Set<TextEffect> = [.italic, .underline]
let text = "Here Be Dragons!"
Terminal.print(
    """
    \(text.invertedLayers)
    \(text.effects(customEffects))
    """
)
```

#### Padding
Align texts in your TUIs using the `pad` method, specifying the alignment for the text, the character to pad with, and how much cells to have filled, including your text area:

```swift
let customPadding = TextPadding(.left, by: 80)
let text = "Here Be Dragons!"
Terminal.print(
    """
    \(text.onMagenta.pad(.center, by: 80))
    \(text.onYellow.pad(using: customPadding))
    \(text.onBlue.pad(.right, with: "-", by: 80))
    """
)
```

## Window
### Dimensions
The dimensions of the terminal window can be retrieved for building TUIs that adapt to the available space or ensuring your software has the space it needs to run:

```swift
guard let dimensions = try? Terminal.dimensions else {
    throwError("cannot retrieve the dimensions of the terminal window.")
}
guard dimensions >= 80 else {
    throwError("the terminal window needs to have, at least, 80 columns.")
}
Terminal.print(
    """
    Total Columns: \(dimensions.totalColumns)
    Total Rows: \(dimensions.totalRows)
    """
)
```

## Help
If you need help related to this project, open a new issue in its [issues pages](https://github.com/skippyr/Teco/issues) or send an [e-mail](mailto:skippyr.developer@icloud.com) describing what is going on.

## Contributing
This project is open to review and possibly accept contributions in the form of bug reports and suggestions. If you are interested, send your contribution to its [pull requests page](https://github.com/skippyr/Teco/pulls) or via [e-mail](mailto:skippyr.developer@icloud.com).

## Copyright
This software is licensed under the MIT License. Refer to the `LICENSE` file that comes in its source code for more details.
