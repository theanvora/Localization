//
//  LocalizationExtras.swift
//  Localization
//
//  Created by AnhPT on 13/07/2026.
//

import SwiftUI

// MARK: - RTL / layout direction

public extension Language {
    /// `true` for right-to-left scripts (Arabic, Hebrew, Farsi, Urdu…).
    var isRTL: Bool {
        Locale.Language(identifier: code).characterDirection == .rightToLeft
    }

    /// The reading direction for this language.
    var layoutDirection: LayoutDirection {
        isRTL ? .rightToLeft : .leftToRight
    }
}

public extension LocalizationManager {
    /// The layout direction for the current language — feed into `\.layoutDirection`.
    var layoutDirection: LayoutDirection {
        Language(code: language).layoutDirection
    }

    var isRTL: Bool { Language(code: language).isRTL }
}

public extension View {
    /// Mirror this subtree to match the localization manager's reading direction,
    /// so RTL languages lay out right-to-left automatically.
    func localizedLayoutDirection(_ manager: LocalizationManager = .shared) -> some View {
        environment(\.layoutDirection, manager.layoutDirection)
    }
}

// MARK: - Pluralization

public extension LocalizationManager {
    /// A pluralized string for `key`, choosing the correct variant for `count`.
    /// Plural rules live in the String Catalog / `.stringsdict` for `key`; this is
    /// clear sugar over passing the count as the format argument.
    func plural(_ key: String, count: Int, _ arguments: CVarArg...) -> String {
        string(key, arguments: [count] + arguments)
    }
}

// MARK: - Per-screen language override

public extension LocalizationManager {
    /// A **scoped** manager for `code` that does *not* swizzle the global bundle.
    /// Inject it with `.localized(_:)` to override the language for one screen.
    static func scoped(to code: String, bundle: Bundle = .main) -> LocalizationManager {
        LocalizationManager(bundle: bundle, defaultLanguage: code, systemWide: false, persistsSelection: false)
    }
}

public extension View {
    /// Override the localization language for **this subtree only** (per-screen),
    /// leaving the rest of the app on its language.
    func localizedLanguage(_ code: String, bundle: Bundle = .main) -> some View {
        modifier(ScopedLanguageModifier(code: code, bundle: bundle))
    }
}

@MainActor
private struct ScopedLanguageModifier: ViewModifier {
    @State private var manager: LocalizationManager

    init(code: String, bundle: Bundle) {
        _manager = State(wrappedValue: LocalizationManager.scoped(to: code, bundle: bundle))
    }

    func body(content: Content) -> some View {
        content
            .localized(manager)
            .localizedLayoutDirection(manager)
    }
}
