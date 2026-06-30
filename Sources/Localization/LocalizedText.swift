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
        Text(l10n.string(key, arguments))
    }
}

public extension View {
    /// Injects a `LocalizationManager` into the environment for this hierarchy.
    func localization(_ manager: LocalizationManager) -> some View {
        environment(manager)
    }
}
