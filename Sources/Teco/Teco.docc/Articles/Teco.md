# ``Teco``
Create terminal software for macOS.
@Metadata {
  @PageImage(purpose: icon, source: "FrameworkIcon", alt: "A framework icon containing a rooster and wheat leaf.")
  @PageColor(red)
}

## Overview
A framework that provides the building blocks for creating line-oriented and screen-oriented terminal apps, while delivering a modern and intuitive developer experience.

Its minimal design invites creative developers to use its features to their favor to create command-line tools and more specialized terminal-related frameworks.

It complements the Apple framework ecosystem by addressing the needs of:
- Server-side applications.
- Prototyping and continution integration (CI) workflows.
- Low-level tooling.
- Other foundational workloads.

## Support
If you need help with this project, you can [open a new issue](https://github.com/skippyr/Teco/issues/new) or [send an email](mailto:skippyr.developer@icloud.com) describing the problem in detail.

## Contributing
Feel free to share suggestions or propose solutions that could help improve this project. If something catches your interest, you're welcome to open a new issue or contribute to an existing one via its [issues page](https://github.com/skippyr/Teco/issues).

## Topics
### Essentials
- <doc:TerminalEvolutionAndArchitecture>
- <doc:TheLineOrientedModel>

### Process
- ``Terminal``

### Streams
- ``WritableStream``

### Text Styling
- ``TextStyle``
- ``StyledTextFragment``
- ``StyledText``
- ``TextLayer``
- ``Color``
- ``ANSIColor``
- ``SRGBColor``
- ``HEXColor``
- ``TextWeight``
- ``TextEffect``
- ``TextAlignment``
- ``TextPadding``
- ``+(_:_:)-(StyledTextFragment,StyledTextFragment)``
- ``+=(_:_:)-(StyledTextFragment,StyledTextFragment)``
- ``+(_:_:)-(StyledTextFragment,StyledText)``
- ``+=(_:_:)-(StyledTextFragment,StyledText)``
- ``+(_:_:)-(StyledText,StyledTextFragment)``
- ``+=(_:_:)-(StyledText,StyledTextFragment)``
- ``+(_:_:)-(StyledText,StyledText)``
- ``+=(_:_:)-(StyledText,StyledText)``

### Screen
- ``CellUnit``
- ``Dimensions``
- ``CleaningRegion``

### Cursor
- ``CursorShape``
