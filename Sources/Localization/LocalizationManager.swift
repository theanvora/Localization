//
//  LocalizationManager.swift
//  Localization
//
//  Created by AnhPT on 02/07/2026.
//

import Foundation
import Observation

/// In-app language switching without an app restart. Picks a per-language
/// `.lproj` bundle and resolves strings through it. Uses the Observation
/// framework (iOS 17+) so SwiftUI views re-render when the language changes.
///
/// ```swift
/// @State private var l10n = LocalizationManager.shared
/// ...
/// .environment(l10n)
/// Text(l10n.string("welcome_title"))
/// Button("VN") { l10n.setLanguage("vi") }
/// ```
@MainActor
@Observable
public final class LocalizationManager {
    public static let shared = LocalizationManager()

    /// Current language code, e.g. "en", "vi".
    public private(set) var language: String

    @ObservationIgnored private var bundle: Bundle
    @ObservationIgnored private let storeKey = "anvora.localization.language"
    @ObservationIgnored private let sourceBundle: Bundle

    /// - Parameters:
    ///   - bundle: where `.lproj` folders live (use `.main`, or `.module` for a package).
    ///   - defaultLanguage: fallback when nothing is stored and the device language isn't available.
    public init(bundle: Bundle = .main, defaultLanguage: String = "en") {
        self.sourceBundle = bundle
        let stored = UserDefaults.standard.string(forKey: storeKey)
        let device = Locale.preferredLanguages.first.map { String($0.prefix(2)) }
        let initial = stored ?? device ?? defaultLanguage
        self.language = initial
        self.bundle = Self.resolveBundle(for: initial, in: bundle) ?? bundle
    }

    /// Available language codes (folders ending in `.lproj`).
    public var availableLanguages: [String] {
        sourceBundle.localizations.filter { $0 != "Base" }.sorted()
    }

    public func setLanguage(_ code: String) {
        guard code != language else { return }
        bundle = Self.resolveBundle(for: code, in: sourceBundle) ?? sourceBundle
        language = code
        UserDefaults.standard.set(code, forKey: storeKey)
    }

    /// Localized string for `key`, optionally formatted with `arguments`.
    public func string(_ key: String, _ arguments: CVarArg...) -> String {
        let format = bundle.localizedString(forKey: key, value: key, table: nil)
        return arguments.isEmpty ? format : String(format: format, arguments: arguments)
    }

    private static func resolveBundle(for code: String, in source: Bundle) -> Bundle? {
        guard let path = source.path(forResource: code, ofType: "lproj") else { return nil }
        return Bundle(path: path)
    }
}
