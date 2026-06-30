//
//  Language.swift
//  Localization
//
//  Created by AnhPT on 02/07/2026.
//

import Foundation

/// A selectable language, with names and a flag for building pickers.
public struct Language: Identifiable, Hashable, Sendable {
    /// Language code, e.g. "en", "vi".
    public let code: String

    public var id: String { code }

    public init(code: String) {
        self.code = code
    }

    public var locale: Locale { Locale(identifier: code) }

    /// The language's name in the user's current UI language (e.g. "Vietnamese").
    public func displayName(in locale: Locale = .current) -> String {
        locale.localizedString(forLanguageCode: code)?.capitalized ?? code
    }

    /// The language's name written in itself (e.g. "Tiếng Việt").
    public var nativeName: String {
        locale.localizedString(forLanguageCode: code)?.capitalized ?? code
    }

    /// A representative flag emoji for the language.
    public var flag: String {
        Self.flags[code] ?? "🏳️"
    }

    private static let flags: [String: String] = [
        "en": "🇬🇧", "vi": "🇻🇳", "ja": "🇯🇵", "ko": "🇰🇷", "zh": "🇨🇳",
        "fr": "🇫🇷", "de": "🇩🇪", "es": "🇪🇸", "it": "🇮🇹", "pt": "🇵🇹",
        "ru": "🇷🇺", "th": "🇹🇭", "id": "🇮🇩", "hi": "🇮🇳", "ar": "🇸🇦",
        "nl": "🇳🇱", "tr": "🇹🇷", "pl": "🇵🇱",
    ]
}
