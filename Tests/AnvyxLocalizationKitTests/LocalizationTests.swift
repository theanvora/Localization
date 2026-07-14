//
//  LocalizationTests.swift
//  Localization
//
//  Created by AnhPT on 02/07/2026.
//

import XCTest
@testable import AnvyxLocalizationKit

@MainActor
final class LocalizationTests: XCTestCase {
    func testFallsBackToKeyWhenMissing() {
        let manager = LocalizationManager(bundle: .main, defaultLanguage: "en")
        // No .lproj resources in tests → unknown key returns the key itself.
        XCTAssertEqual(manager.string("nonexistent_key"), "nonexistent_key")
    }

    func testSetLanguageUpdatesProperty() {
        let manager = LocalizationManager(bundle: .main, defaultLanguage: "en")
        manager.setLanguage("vi")
        XCTAssertEqual(manager.language, "vi")
    }
}

// MARK: - Translation fallback (on-device provider)

final class TranslationFallbackTests: XCTestCase {
    @MainActor
    func testMissingKeyUsesBaseThenCachedTranslation() async {
        let manager = LocalizationManager(bundle: .module, defaultLanguage: "en",
                                          systemWide: false, persistsSelection: false)
        manager.translationProvider = { text, _ in "FR:\(text)" }
        manager.setLanguage("fr")   // fr.lproj lacks "greeting"

        // Immediately: base-language text while the translation is in flight.
        XCTAssertEqual(manager.string("greeting"), "Hello")

        // After the async provider fills the cache: the translated string.
        for _ in 0..<100 where manager.string("greeting") == "Hello" {
            try? await Task.sleep(nanoseconds: 5_000_000)
        }
        XCTAssertEqual(manager.string("greeting"), "FR:Hello")
    }

    @MainActor
    func testNoProviderKeepsBaseText() {
        let manager = LocalizationManager(bundle: .module, defaultLanguage: "en",
                                          systemWide: false, persistsSelection: false)
        manager.setLanguage("fr")
        XCTAssertEqual(manager.string("greeting"), "Hello")   // base fallback, no crash
    }
}
