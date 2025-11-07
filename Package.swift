// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Teco",
    platforms: [.macOS(.v14)],
    products: [.library(name: "Teco", targets: ["Teco"])],
    targets: [.target(name: "Teco")]
)
