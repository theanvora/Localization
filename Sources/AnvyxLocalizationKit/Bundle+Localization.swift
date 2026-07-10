//
//  Bundle+Localization.swift
//  Localization
//
//  Created by AnhPT on 02/07/2026.
//

import Foundation
import ObjectiveC

/// A `Bundle` subclass that redirects `localizedString(...)` to a chosen language
/// bundle. Installed onto `Bundle.main` so that **every** localized lookup — plain
/// `Text("key")`, String Catalogs, `NSLocalizedString`, even UIKit — resolves to
/// the in-app selected language without an app restart.
///
/// `@unchecked Sendable`: `Bundle` is a non-final `NSObject`, so its `Sendable`
/// conformance cannot be checked by the compiler. This subclass adds no mutable
/// stored state of its own — it only overrides `localizedString(...)` to consult
/// an immutable associated-object override — so it is safe to share across
/// isolation domains exactly as `Bundle` itself already is.
final class LocalizedBundle: Bundle, @unchecked Sendable {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        // Guard `override !== self`: when the selected bundle falls back to
        // `Bundle.main` (which has itself been reclassed to `LocalizedBundle`),
        // forwarding to it would call this same method forever. In that case just
        // use the superclass lookup.
        if let override = objc_getAssociatedObject(self, &Self.key) as? Bundle, override !== self {
            return override.localizedString(forKey: key, value: value, table: tableName)
        }
        return super.localizedString(forKey: key, value: value, table: tableName)
    }

    // Used only for its stable address as an Objective-C associated-object key;
    // the byte value is never read or mutated, so `nonisolated(unsafe)` is safe
    // here (a raw-pointer key cannot itself be `Sendable`).
    private nonisolated(unsafe) static var key: UInt8 = 0

    /// Swap `Bundle.main`'s class once and point it at `languageBundle`
    /// (pass `nil` to fall back to the system language).
    static func install(_ languageBundle: Bundle?) {
        if !(Bundle.main is LocalizedBundle) {
            object_setClass(Bundle.main, LocalizedBundle.self)
        }
        objc_setAssociatedObject(Bundle.main, &key, languageBundle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
