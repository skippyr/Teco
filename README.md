# Teco
## About
A terminal manipulation Swift 6.2 library for building macOS command-line tools. It encourages developers to create simple, line-oriented utilities—tools that parse arguments, perform a task, and print results—perfect for housekeeping scripts and system maintenance workflows.

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
This section will give you an overview about the library. For more details, refer to the documentation of its components on Xcode.

### Import
Import it at the top of your Swift files:

```swift
import Teco
```

The main component brought to scope is the `Terminal` class, which is as a handle for manipulating the emulated terminal. To ensure thread safety, you can only use it within `MainActor.run`.

### Printing
Use the `Terminal.print` method for writing to writable streams. It works similar to the standard `print` function, but you can specify a stream using the `via` label.

```swift
await MainActor.run {
    Terminal.print("(output) Here Be Dragons!")
    Terminal.print("(error) Here Be Dragons!", via: .error)
}
```

### Styles
Strings are associated with styles (`Terminal.Style`) using extension methods and interpolation, creating styled fragments (`Terminal.StyledFragment`) and styled strings (`Terminal.StyledString`).

```swift
let style = Terminal.Style(foreground: .yellow, effects: [.underline])
let styledFragment = "Dragons".red.bold
let styledString = "\(Here.style(style)) \("Be".yellow) \(styledFragment)"
```

A styled fragment wraps a string with a style, while a styled string glues fragments in order to create a full text. Fragments and strings are usually converted to styled strings using its constructor, while string literals can be automatically converted by specifying the type.

```swift
let styledStringFromFragment = Terminal.StyledString("Here Be Dragons!".red)
let styledStringFromString = Terminal.StyledString("Here Be Dragons!")
let styledStringFromStringLiteral: Terminal.StyledString = "Here Be Dragons!"
```

Styled strings can be concatenated and interpolated—but deep nesting is error prone. At any time, you can access the underlying string being wrapped using the `string` method.

```swift
let message = "Here ".red +
              "Be Dragons!"
                  .srgb(red: 0, green: 0, blue: 0)
                  .onSRGB(red: 255, green: 255, blue: 0)
                  .blinking
                  .pad(.center, by: 21)
let labelStyle = Terminal.Style(weight: .bold, padding: .init(.left, by: 25))
let wrappedMessage = message.string
await MainActor.run {
    Terminal.print("""
      \("Message (with styles):".style(labelStyle)) \(message)
      \("Message (Without styles):".style(labelStyle)) \(wrappedMessage)
      \("Total Characters:".style(labelStyle)) \(wrappedMessage.description.yellow)
      """)
}
```

Styles can affect colors, font weight, effects and padding. Both ANSI 256 color palette and RGB colors from sRGB color space are supported.

The true magic happens within the `Terminal.print`, as it's the responsible for parsing the fragments in your styled strings and converting their styles to ANSI escape sequences during runtime.

Styles, except padding, are automatically removed if the stream specified to `Terminal.print` is redirected or the styled strings are cast to regular strings.

Additionaly, by default, styles are not applied if the environment variable `NO_COLOR` is set or if the terminal identifier (hold by the `TERM` environment variable) is `dumb`—meaning no capabilities are supported. You can override this preference (`Terminal.shouldApplyStyles`), for example, to also be controlled by a custom option:

```swift
await MainActor.run {
    for argument in CommandLine.arguments.dropFirst() {
        if argument == "--no-color" {
            Terminal.shouldApplyStyles = false
            break
        }
    }
}
```

### Streams
The `Terminal` class caches information if the streams are redirected. You can access them and perform checks to guarantee your app is be able to use them.

```swift
await MainActor.run {
    guard !Terminal.isOutputRedirected && !Terminal.isErrorRedirected else {
        Terminal.print("error: the output streams cannot be redirected.", via: .error)
        exit(EXIT_FAILURE)
    }
}
```

### Dimensions
Lastly, the dimensions of the terminal window can be retrieved:

```swift
await MainActor.run {
    guard let dimensions = try? Terminal.dimensions else {
        Terminal.print("error: cannot retrieve the dimensions of the terminal window.", via: .error)
        exit(EXIT_FAILURE)
    }
    Terminal.print("""
        Total Columns: \(dimensions.totalColumns)
        Total Rows: \(dimensions.totalRows)
        """)
}
```

## Help
If you need help related to this project, open a new issue in its [issues pages](https://github.com/skippyr/Teco/issues) or send an [e-mail](mailto:skippyr.developer@icloud.com) describing what is going on.

## Contributing
This project is open to review and possibly accept contributions in the form of bug reports and suggestions. If you are interested, send your contribution to its [pull requests page](https://github.com/skippyr/Teco/pulls) or via [e-mail](mailto:skippyr.developer@icloud.com).

## Copyright
This software is licensed under the MIT License. Refer to the `LICENSE` file that comes in its source code for more details.
