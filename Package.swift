// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Localization",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "AnvyxLocalizationKit", targets: ["AnvyxLocalizationKit"]),
    ],
    targets: [
        .target(name: "AnvyxLocalizationKit"),
        .testTarget(name: "AnvyxLocalizationKitTests", dependencies: ["AnvyxLocalizationKit"]),
    ]
)
