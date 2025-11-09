# Teco
## About
A terminal manipulation Swift library for building simple macOS command-line tools—that parse arguments, perform a task, and print results—, making it perfect for system maintenance workflows. It requires Swift 6.2 and macOS 14 Sonoma or newer.

## Install
### Swift Package Manager
Adapting it to your case:
- Add it to your package dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/skippyr/Teco", from: "1.0.0")
],
```

- Make the desired targets use it:

```swift
targets: [
    .executableTarget(
        name: "App",
        dependencies: ["Teco"]
    )
]
```

### Xcode Project
- Open your project settings.
- Click on the `+` button under the `General > Frameworks and Libraries` section.
- Use the `Add Other...` dropdown menu at the bottom left corner, selecting the `Add Package Dependency...` option.
- Use the `Search or Enter Package URL` search bar at the top right corner to search for the `https://github.com/skippyr/Teco` repository.
- Select the `Teco` package in the result list and click on the `Add Package` button at the bottom right corner.
- Choose the desired targets to be using it and click on the `Add Package` button again.

## Usage
This section will give you an overview about the library. For more details, refer to the documentation of its components by holding the Option key and clicking on them on Xcode.

### Import & Thread Safety Note
The main component brought to scope is the `Terminal` class, which is as a handle for manipulating the emulated terminal. To ensure thread safety when building UI and accessing cached values, you can only use it within the main actor concurrency domain.

For that, it's highly recommended you use modern Swift annotations such as `@main` and `@MainActor` to denotate your software entry point and UI/terminal manipulation functions, respectively—which both should run in the main thread—reducing code and mitigating date races—for beginners, also worth to mention you cannot use `@main` within a file named `main.swift`.

```swift
// App.swift
//
// But this can be any name other than main.swift.

import Teco
import Foundation

@main
struct App {
    @MainActor
    static func foo() {
        // Write UI/terminal manipulation code in functions annotated with
        // @MainActor.

        // ...
    }

    static func main() {
        // The main function in objects annotated with @main is always run
        // within the main actor domain.
        //
        // You can access Teco features and @MainActor functions here without
        // awaiting them.

        // ...
    }
}
```

If you still prefer to use top-level code within the `main.swift` file, write your code within `MainActor.run` and await its completion.

```swift
// main.swift

await MainActor.run {
    // ...
}
```

All examples throughout this documentation will implicitly assume you run them via the main actor using one of the methods described above.

### Printing
Use the `Terminal.print` method for writing to writable streams. It works similar to the standard `print` function.

```swift
// Without specifying a stream using the `via:` label, it considers the terminal
// output stream.
Terminal.print("(output) Here Be Dragons!")

// Not providing an argument, makes it print the newline sequence.
Terminal.print()

// You can manually specify you want to write to the terminal error stream.
Terminal.print("(error) Here Be Dragons!", via: .error)

// It can print `Any` type by converting it to its string description.
//
// Implement the `CustomStringConvertible` protocol to your types for custom
// output.
Terminal.print(30)
```

### Styles
Inspired by libraries such as [Rainbow](http://github.com/onevcat/Rainbow) and [ANSIKit](https://github.com/tornikegomareli/ANSIKit), Teco associates strings with styles using extension methods and string interpolation. However, instead of appending ANSI sequences to your strings in place, it uses dedicated types that allows you to create and reuse styles (`Terminal.Style`), styled fragments (`Terminal.StyledFragment`) and styled strings (`Terminal.StyledString`) throughout your apps, giving you more flexibility.

A style is a set of properties that define the appearance of a single string fragment. A styled fragment is a type that relates a string with a style. And, finally, a styled string glues fragments together to create a complete text, which may contain different styles mixed.

```swift
// You can define custom styles to later associate it with strings.
let customStyle = Terminal.Style(foreground: .yellow, effects: [.underline])

// Alternatively, you can directly associate a style with a string using
// extension methods, therefore creating a styled fragment.
let styledFragment = "Dragons".red.bold
// This one associates "Dragons" with red foreground and bold font weight.

// Finally, you can interpolate strings and styled fragments, glueing them
// together, forming a styled string.
//
// Note, the custom style previously create is used here.
let styledString = "\(Here.style(customStyle)) \("Be".yellow) \(styledFragment)!"
// This styled string, for example, is composed by 6 styled fragments:
//     1. "Here" with yellow foreground and underline effect (defined by
//        `customStyle` style).
//     2. " " with blank style.
//     3. "Be" with yellow foreground.
//     4. " " with blank style.
//     5. "Dragons" with red foreground and bold font weight (stored in
//        `styledFragment` variable).
//     6. "!" with blank style.

// Use `Terminal.print` to print your styled strings with them applied.
Terminal.print(styledString)
```

> [!IMPORTANT]
> The Xcode built-in console emulates the `dumb` terminal. It doesn't render styles neither supports advanced features.
>
> For debugging purposes, always prefer to use the Terminal app. And if you have installed a custom profile for it, worth ensuring it still configured to declare itself as `xterm-256color` under its settings `Profiles > Advanced` tab.

Often, fragments and strings are converted to styled strings using its constructor, while string literals can be automatically converted by specifying the type. Styled strings can be concatenated and interpolated—but deep nesting is error prone because Swift, without type annotation, infers string literals are just regular strings. At any time, you can access the underlying string being wrapped using the `string` method.

```swift
// Convert styled fragments and string literals to styled strings using its
// constructor.
let styledStringFromFragment = Terminal.StyledString("Here Be Dragons!".red)
let styledStringFromString = Terminal.StyledString("Here Be Dragons!")
// Alternatively, a string literal can be automatically casted if you make the
// type explicit.
let styledStringFromStringLiteral: Terminal.StyledString = "Here Be Dragons!"

// Accessing the string from a styled fragment is simply accessing the value
// being wrapped—without performance costs.
let fragment = "Here Be Dragons".red
Terminal.print(fragment.string)
// In contrast, accessing the string from a styled string allocates on the heap,
// because it needs to concatenate the text from its fragments to synthesize it
// completely.
//
// It's a good idea to save it to a variable if you need to manipulate it more
// than once.
let styledString = "\(fragment)\("!".yellow)"
Terminal.print(styledString.string)
```

Styles can affect colors, font weight, effects and padding. Both ANSI 256 color palette and RGB colors from sRGB color space are supported. The true magic happens within the `Terminal.print`, as it's the responsible for parsing the fragments in your styled strings and converting their styles to ANSI escape sequences during runtime.

```swift
Terminal.print("""
    \("In memory of all fellow dragons,".bold.red)
    \("whose dreams".blue.bold) keep our \("flames alive".srgb(red: 255, green: 128, blue: 0))
    \("forever".invertedLayers) \("keeping".underline.pad(.left, by: 10)) our \("cave apart".yellow).
    """)
```

Styles, except padding, are automatically removed if the stream specified to `Terminal.print` is redirected or the styled strings are cast to regular strings. Additionaly, by default, styles are not applied if the environment variable `NO_COLOR` is set or if the terminal identifier (hold by the `TERM` environment variable) is `dumb`—meaning no capabilities are supported. You can override this preference (`Terminal.shouldApplyStyles`), for example, to also be controlled by a custom CLI option:

```swift
CommandLine.arguments
    .dropFirst()
    .map { $0.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) }
    .forEach { argument in
        if argument == "--no-color" {
            // Disables styles if the `--no-color` CLI option is used among the
            // command-line arguments.
            Terminal.shouldApplyStyles = false
            return
        } else if argument == "-h" || argument == "--help" {
            // writeHelp()
            exit(EXIT_SUCCESS)
        }
    }
```

### Streams
The `Terminal` class caches whether the streams are being redirected. Even though, these values can technically stale, that's very unlikely to happen for most apps—making it a reasonable approach to improve performance. You can access those values and perform checks to guarantee your app is be able to use them.

```swift
// For interactive apps, you can check for the input stream.
guard !Terminal.isInputRedirected else {
    Terminal.print("error: the input stream cannot be redirected.", via: .error)
    exit(EXIT_FAILURE)
}

// Otherwise, you can check for a set of output streams.
guard !Terminal.isOutputRedirected && !Terminal.isErrorRedirected else {
    Terminal.print("error: the output streams cannot be redirected.", via: .error)
    exit(EXIT_FAILURE)
}
```

### Dimensions
Finally, the dimensions of the terminal window can be retrieved for building UIs that adapt to the available space:

```swift
guard let dimensions = try? Terminal.dimensions else {
    Terminal.print("error: cannot retrieve the dimensions of the terminal window.", via: .error)
    exit(EXIT_FAILURE)
}

// Print the dimensions for debugging.
Terminal.print("""
    Total Columns: \(dimensions.totalColumns)
    Total Rows: \(dimensions.totalRows)
    """)

// Check if the dimensions have the minimum size for your UI.
guard dimensions.totalColumns < 80 else {
    Terminal.print("error: cannot retrieve the dimensions of the terminal window.", via: .error)
    exit(EXIT_FAILURE)
}

// Alternatively, adapt your UI to the available space.
if dimensions.totalColumns > 100 {
    // printLargeUI()
} else {
    // printSmallUI()
}
```

## Help
If you need help related to this project, open a new issue in its [issues pages](https://github.com/skippyr/Teco/issues) or send an [e-mail](mailto:skippyr.developer@icloud.com) describing what is going on.

## Contributing
This project is open to review and possibly accept contributions in the form of bug reports and suggestions. If you are interested, send your contribution to its [pull requests page](https://github.com/skippyr/Teco/pulls) or via [e-mail](mailto:skippyr.developer@icloud.com).

## Copyright
This software is licensed under the MIT License. Refer to the `LICENSE` file that comes in its source code for more details.
