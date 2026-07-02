// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Localization",
    platforms: [
        .iOS("26.0")
    ],
    products: [
        .library(name: "Localization", targets: ["Localization"]),
    ],
    targets: [
        .target(name: "Localization"),
        .testTarget(name: "LocalizationTests", dependencies: ["Localization"]),
    ]
)
