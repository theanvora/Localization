//
//  LocalizedText.swift
//  Localization
//
//  Created by AnhPT on 02/07/2026.
//

import SwiftUI

/// A `Text` that resolves its key through the `LocalizationManager` in the
/// environment, so it updates live when the language changes.
///
/// ```swift
/// LocalizedText("welcome_title")
/// LocalizedText("items_count", 5)
/// ```
public struct LocalizedText: View {
    @Environment(LocalizationManager.self) private var l10n
    private let key: String
    private let arguments: [CVarArg]

    public init(_ key: String, _ arguments: CVarArg...) {
        self.key = key
        self.arguments = arguments
    }

    public var body: some View {
        Text(l10n.string(key, arguments: arguments))
    }
}

public extension View {
    /// Injects a `LocalizationManager` **and** the matching `\.locale` into the
    /// environment, so localized strings, dates, numbers, and plurals all follow
    /// the selected language. The one modifier you need at the app root.
    func localized(_ manager: LocalizationManager = .shared) -> some View {
        environment(manager)
            .environment(\.locale, manager.locale)
    }
}

public extension String {
    /// Localizes the receiver as a key through the shared `LocalizationManager`.
    @MainActor var localized: String {
        LocalizationManager.shared(self)
    }

    /// Localizes and formats with arguments through the shared manager.
    @MainActor func localized(_ arguments: CVarArg...) -> String {
        LocalizationManager.shared.string(self, arguments: arguments)
    }
}
