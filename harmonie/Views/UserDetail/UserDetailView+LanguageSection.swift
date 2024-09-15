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
            HStack(spacing: 8) {
                ForEach(user.tags.languageTags) { language in
                    Text(language.description)
                        .font(.footnote.bold())
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color(.systemFill))
                        .cornerRadius(8)
                }
            }
        }
    }
}
