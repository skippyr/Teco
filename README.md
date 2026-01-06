<img alt="A framework icon containing a rooster and wheat leaf." src="Assets/FrameworkIcon.png" width="90" />

# Teco

> [!IMPORTANT]
> **Deprecation Notice**
>
> Teco's scope and evolution were not well planned, which led to growing complexity without meaningful benefits. Additionally, the project is being discontinued in favor of a move to GitLab, which offers more suitable features.
>
> If you were using [Teco](https://github.com/skippyr/Teco), you should migrate to [RoosterTTY](https://gitlab.com/skippyr/RoosterTTY). It focuses on line-oriented applications and keeps a familiar API, but it is not fully compatible, so some code changes will be required. This repository will remain archived and available for legacy use.

## About
A framework that provides the building blocks for creating line-oriented and screen-oriented terminal apps, while delivering a modern and intuitive developer experience.

Its minimal design invites creative developers to use its features to their favor to create command-line tools and more specialized terminal-related frameworks.

It complements the Apple framework ecosystem by addressing the needs of:
- Server-side applications.
- Prototyping and continution integration (CI) workflows.
- Low-level tooling.
- Other foundational workloads.

## Install
### Using Swift Package Manager (SPM)
- Ensure your package supports, at least, macOS 14 (Sonoma).

```swift
platforms: [
    .macOS(.v14)
]
```

- Add the framework as one of your dependencies.

```swift
dependencies: [
    .package(
        url: "https://github.com/skippyr/Teco",
        from: "1.0.0"
    )
]
```

- Make your target depend on it.

```swift
.executableTarget(
    name: "YourApp",
    dependencies: ["Teco"]
)
```

### Using an Xcode Project
- Open your target settings.
- Ensure your target has, at least, macOS 14 (Sonoma) as the minimum deployment version.
- Click on the `+` button under the **General → Frameworks and Libraries** section.
- Use the `Add Other...` dropdown menu at the bottom left corner, selecting the `Add Package Dependency...` option.
- Use the `Search or Enter Package URL` search bar at the top right corner to search for the `https://github.com/skippyr/Teco` repository.
- Select the `teco` package in the result list and click on the `Add Package` button at the bottom right corner.
- Choose the desired targets to be using it and click on the `Add Package` button again.
- For the best experience, if possible, ensure your project uses `Swift 6` as the language version under its **Build Settings**.

## Documentation
You can view the framework’s documentation directly in Xcode by building the documentation for the dependent target using **Product → Build Documentation**.

## Support
If you need help with this project, you can [open a new issue](https://github.com/skippyr/Teco/issues/new) or [send an email](mailto:skippyr.developer@icloud.com) describing the problem in detail.

## Contributing
Feel free to share suggestions or propose solutions that could help improve this project. If something catches your interest, you're welcome to open a new issue or contribute to an existing one via its [issues page](https://github.com/skippyr/Teco/issues).

## Copyright
This software is distributed under the MIT License. For complete terms, see the accompanying `LICENSE` file included in the source code. When applicable, a `NOTICE` file may also be provided to acknowledge copyrights or other attributions for third-party components.
