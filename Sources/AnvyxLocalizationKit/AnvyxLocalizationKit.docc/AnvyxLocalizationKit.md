# ``AnvyxLocalizationKit``

In-app language switching without a restart, with RTL support, pluralization, and
per-screen language overrides.

## Overview

``LocalizationManager`` is an `@Observable` that swaps the active `.lproj` bundle at
runtime (works with `.strings` and String Catalogs), so the whole UI re-localizes
live. Inject it with `.localized(_:)` and read keys via ``LocalizedText`` or the
`String.localized` sugar.

```swift
ContentView().localized(.shared)          // manager + \.locale
LocalizedText("welcome_title")
DetailView().localizedLanguage("ja")      // this screen only
```

## Topics

### Manager
- ``LocalizationManager``
- ``Language``

### Views
- ``LocalizedText``
- ``LanguagePicker``
