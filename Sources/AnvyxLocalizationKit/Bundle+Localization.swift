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
final class LocalizedBundle: Bundle, @unchecked Sendable {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let override = objc_getAssociatedObject(self, &Self.key) as? Bundle {
            return override.localizedString(forKey: key, value: value, table: tableName)
        }
        return super.localizedString(forKey: key, value: value, table: tableName)
    }

    private static var key: UInt8 = 0

    /// Swap `Bundle.main`'s class once and point it at `languageBundle`
    /// (pass `nil` to fall back to the system language).
    static func install(_ languageBundle: Bundle?) {
        if !(Bundle.main is LocalizedBundle) {
            object_setClass(Bundle.main, LocalizedBundle.self)
        }
        objc_setAssociatedObject(Bundle.main, &key, languageBundle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
