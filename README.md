# Localization

In-app language switching for iOS — change the app's language at runtime without
a restart, powered by the Observation framework (iOS 17+).

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/iOS-17%2B-blue.svg)](https://developer.apple.com/ios/)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)

## Features

- **`LocalizationManager`** — an `@Observable` that selects a per-language `.lproj`
  bundle and persists the choice. SwiftUI views re-render on change.
- **`LocalizedText`** — a `Text` that reads its key from the manager in the environment.
- Device-language detection with a configurable fallback, and `availableLanguages`.

## Installation

```swift
.package(url: "https://github.com/anvyxhq/Localization.git", from: "1.0.0")
```

## Usage

Add `.lproj` files (e.g. `en.lproj/Localizable.strings`, `vi.lproj/Localizable.strings`)
to your app target, then:

```swift
import Localization

@main
struct MyApp: App {
    @State private var l10n = LocalizationManager.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .localization(l10n)   // inject into the environment
        }
    }
}

// In any view
LocalizedText("welcome_title")
Button("Tiếng Việt") { l10n.setLanguage("vi") }

// Or resolve a string directly
let msg = l10n.string("items_count", 5)   // supports String(format:) args
```

## Requirements

- iOS 17.0+ · Swift 5.9+

## License

MIT
