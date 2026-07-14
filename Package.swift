// swift-tools-version: 6.2
import PackageDescription

let concurrencyBaseline: [SwiftSetting] = [
    .swiftLanguageMode(.v6),
    .defaultIsolation(nil),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    .enableUpcomingFeature("InferIsolatedConformances"),
]

let package = Package(
    name: "Localization",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "AnvyxLocalizationKit", targets: ["AnvyxLocalizationKit"]),
    ],
    targets: [
        .target(name: "AnvyxLocalizationKit", swiftSettings: concurrencyBaseline),
        .testTarget(
            name: "AnvyxLocalizationKitTests",
            dependencies: ["AnvyxLocalizationKit"],
            resources: [.copy("Resources/en.lproj"), .copy("Resources/fr.lproj")],
            swiftSettings: concurrencyBaseline
        ),
    ]
)
