//
//  LocalizationManager.swift
//  Localization
//
//  Created by AnhPT on 02/07/2026.
//

import Foundation
import Observation

/// In-app language switching without an app restart, using the Observation
/// framework (iOS 17+). Resolves strings from the selected language's `.lproj`
/// bundle — works with both legacy `.strings` files and modern **String Catalogs
/// (`.xcstrings`)**, which compile into the same per-language tables.
///
/// The most convenient setup is a single modifier that injects both the manager
/// and the SwiftUI `\.locale` (so dates/numbers/plurals follow the language too):
///
/// ```swift
/// @State private var l10n = LocalizationManager.shared
///
/// ContentView()
///     .localized(l10n)            // inject manager + environment locale
///
/// // then, anywhere:
/// Text(l10n("welcome_title"))     // callAsFunction
/// "items_count".localized(5)      // String sugar via the shared manager
/// ```
@MainActor
@Observable
public final class LocalizationManager {
    public static let shared = LocalizationManager()

    /// Current language code, e.g. "en", "vi".
    public private(set) var language: String

    /// Locale derived from the current language — feed this into `\.locale`.
    public var locale: Locale { Locale(identifier: language) }

    @ObservationIgnored private var bundle: Bundle
    @ObservationIgnored private let sourceBundle: Bundle
    @ObservationIgnored private let systemWide: Bool
    @ObservationIgnored private let storeKey = "anvyx.localization.language"

    /// - Parameters:
    ///   - bundle: where `.lproj` folders live (`.main`, or `.module` for a package).
    ///   - defaultLanguage: fallback when nothing is stored and the device language isn't available.
    ///   - systemWide: when `true` (default), swizzles `Bundle.main` so even plain
    ///     `Text("key")` / `NSLocalizedString` switch instantly. Set `false` to only
    ///     affect `LocalizedText` / `l10n(...)` lookups.
    public init(bundle: Bundle = .main, defaultLanguage: String = "en", systemWide: Bool = true) {
        self.sourceBundle = bundle
        self.systemWide = systemWide
        let stored = UserDefaults.standard.string(forKey: storeKey)
        let device = Locale.preferredLanguages.first.map { String($0.prefix(2)) }
        let initial = stored ?? device ?? defaultLanguage
        self.language = initial
        self.bundle = Self.resolveBundle(for: initial, in: bundle) ?? bundle
        applySystemWide()
    }

    /// Languages bundled with the app (folders ending in `.lproj`), as rich models.
    public var availableLanguages: [Language] {
        sourceBundle.localizations
            .filter { $0 != "Base" }
            .map(Language.init(code:))
            .sorted { $0.nativeName < $1.nativeName }
    }

    public func setLanguage(_ code: String) {
        guard code != language else { return }
        bundle = Self.resolveBundle(for: code, in: sourceBundle) ?? sourceBundle
        language = code
        UserDefaults.standard.set(code, forKey: storeKey)
        applySystemWide()
    }

    private func applySystemWide() {
        guard systemWide, sourceBundle == .main else { return }
        LocalizedBundle.install(bundle)
    }

    public func setLanguage(_ language: Language) {
        setLanguage(language.code)
    }

    // MARK: - Lookup

    /// Localized string for `key`, optionally formatted with `arguments`.
    public func string(_ key: String, _ arguments: CVarArg...) -> String {
        localized(key, arguments)
    }

    /// Sugar so the manager is callable directly: `l10n("key")`.
    public func callAsFunction(_ key: String, _ arguments: CVarArg...) -> String {
        localized(key, arguments)
    }

    /// Array-based overload for forwarding already-collected arguments.
    public func string(_ key: String, arguments: [CVarArg]) -> String {
        localized(key, arguments)
    }

    private func localized(_ key: String, _ arguments: [CVarArg]) -> String {
        let format = bundle.localizedString(forKey: key, value: key, table: nil)
        return arguments.isEmpty ? format : String(format: format, locale: locale, arguments: arguments)
    }

    private static func resolveBundle(for code: String, in source: Bundle) -> Bundle? {
        guard let path = source.path(forResource: code, ofType: "lproj") else { return nil }
        return Bundle(path: path)
    }
}
