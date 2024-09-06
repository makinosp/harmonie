//
//  UserDetailView+LanguageSection.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/06.
//

import SwiftUI
import VRCKit

extension UserDetailView {
    var languageSection: some View {
        SectionView {
            Text("Languages")
                .font(.subheadline)
                .foregroundStyle(Color.gray)
            VStack(alignment: .leading, spacing: 8) {
                ForEach(user.tags.languageTags) { language in
                    Text(language.description)
                        .font(.body)
                }
            }
        }
    }
}
