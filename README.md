# Localization

Instant, restart-free in-app language switching for iOS — tap a language and the
**entire app** changes immediately. Powered by the Observation framework (iOS 17+)
and works with both legacy `.strings` and modern **String Catalogs (`.xcstrings`)**.

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/iOS-17%2B-blue.svg)](https://developer.apple.com/ios/)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)

## Highlights

- **Switch the whole app instantly.** Picking a language updates everything —
  including plain `Text("key")`, `NSLocalizedString`, and UIKit — with no restart.
- **One modifier.** `.localized()` injects the manager *and* the SwiftUI `\.locale`,
  so strings, dates, numbers, and plurals all follow the selected language.
- **Drop-in UI.** `LanguagePicker` renders a ready-made settings list with flags +
  native names and a checkmark on the active language.
- **Modern & convenient.** `@Observable` manager, `callAsFunction`, and a
  `String.localized` shorthand.

## Installation

```swift
.package(url: "https://github.com/anvyxhq/Localization.git", from: "2.0.0")
```

## Setup

Add `.lproj` files (or a String Catalog) to your **app** target — e.g.
`en.lproj/Localizable.strings`, `vi.lproj/Localizable.strings` — then:

```swift
import Localization

@main
struct MyApp: App {
    @State private var l10n = LocalizationManager.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .localized(l10n)   // ← inject manager + environment locale
        }
    }
}
```

## Switching language (Settings screen)

Tapping a row switches the app immediately:

```swift
NavigationStack {
    LanguagePicker()
        .navigationTitle("Language")
}
```

…or do it manually from anywhere:

```swift
l10n.setLanguage("vi")   // app updates instantly, choice is persisted
```

## Reading strings

```swift
LocalizedText("welcome_title")        // SwiftUI, live-updating
Text(l10n("welcome_title"))           // callAsFunction
"items_count".localized(5)            // String sugar + format args
```

## How instant switching works

`LocalizationManager` (default `systemWide: true`) swizzles `Bundle.main` to point
at the selected language bundle, while `.localized()` updates the environment
`\.locale`. SwiftUI re-renders and every localized lookup resolves to the chosen
language — no app relaunch. Pass `systemWide: false` to limit switching to
`LocalizedText` / `l10n(...)` only.

## Requirements

- iOS 17.0+ · Swift 5.9+

## License

MIT
