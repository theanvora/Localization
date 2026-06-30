//
//  LanguagePicker.swift
//  Localization
//
//  Created by AnhPT on 02/07/2026.
//

import SwiftUI

/// A drop-in language selection list. Reads the available languages from the
/// `LocalizationManager` in the environment and switches on tap.
///
/// ```swift
/// NavigationStack { LanguagePicker() }
///     .localized(l10n)
/// ```
public struct LanguagePicker: View {
    @Environment(LocalizationManager.self) private var l10n

    public init() {}

    public var body: some View {
        List(l10n.availableLanguages) { language in
            Button {
                l10n.setLanguage(language)
            } label: {
                HStack(spacing: 12) {
                    Text(language.flag)
                        .font(.title2)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(language.nativeName)
                            .foregroundStyle(.primary)
                        Text(language.displayName())
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    if language.code == l10n.language {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.tint)
                    }
                }
            }
        }
    }
}
