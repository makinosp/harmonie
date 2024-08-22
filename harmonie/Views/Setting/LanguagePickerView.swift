//
//  LanguagePickerView.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/23.
//

import SwiftUI
import VRCKit

struct LanguagePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedLanguage: LanguageTag?

    var body: some View {
        NavigationStack {
            Form {
                ForEach(LanguageTag.allCases) { languageTag in
                    Button {
                        selectedLanguage = languageTag
                        dismiss()
                    } label: {
                        Text(languageTag.description)
                    }
                }
            }
            .labelsHidden()
            .navigationTitle("Languages")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}
