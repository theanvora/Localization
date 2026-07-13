//
//  LocalizationExtrasTests.swift
//  Localization
//
//  Created by AnhPT on 13/07/2026.
//

import XCTest
import SwiftUI
@testable import AnvyxLocalizationKit

final class LocalizationExtrasTests: XCTestCase {

    // MARK: - RTL

    func testRTLDetection() {
        XCTAssertTrue(Language(code: "ar").isRTL)
        XCTAssertTrue(Language(code: "he").isRTL)
        XCTAssertFalse(Language(code: "en").isRTL)
        XCTAssertFalse(Language(code: "vi").isRTL)
        XCTAssertFalse(Language(code: "ja").isRTL)
    }

    func testLanguageLayoutDirection() {
        XCTAssertEqual(Language(code: "ar").layoutDirection, .rightToLeft)
        XCTAssertEqual(Language(code: "en").layoutDirection, .leftToRight)
    }

    @MainActor
    func testManagerLayoutDirection() {
        XCTAssertEqual(LocalizationManager.scoped(to: "ar").layoutDirection, .rightToLeft)
        XCTAssertTrue(LocalizationManager.scoped(to: "he").isRTL)
        XCTAssertEqual(LocalizationManager.scoped(to: "en").layoutDirection, .leftToRight)
        XCTAssertFalse(LocalizationManager.scoped(to: "vi").isRTL)
    }

    // MARK: - Per-screen scope

    @MainActor
    func testScopedManagersAreIndependent() {
        let vietnamese = LocalizationManager.scoped(to: "vi")
        let japanese = LocalizationManager.scoped(to: "ja")

        XCTAssertEqual(vietnamese.language, "vi")
        XCTAssertEqual(japanese.language, "ja")
        XCTAssertEqual(vietnamese.locale.identifier, "vi")
        XCTAssertEqual(japanese.locale.identifier, "ja")
        // A scoped manager must not disturb the shared one.
        XCTAssertNotIdentical(vietnamese, LocalizationManager.shared)
    }

    // MARK: - Pluralization

    @MainActor
    func testPluralConvenienceFormatsWithCount() {
        // No catalog in the test bundle, so the key falls through; the call must
        // still be safe and return a non-empty string.
        let result = LocalizationManager.shared.plural("items_count", count: 3)
        XCTAssertFalse(result.isEmpty)
    }
}
