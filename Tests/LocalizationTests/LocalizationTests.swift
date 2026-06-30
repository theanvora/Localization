//
//  LocalizationTests.swift
//  Localization
//
//  Created by AnhPT on 02/07/2026.
//

import XCTest
@testable import Localization

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
