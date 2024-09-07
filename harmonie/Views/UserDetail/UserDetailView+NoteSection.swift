//
//  UserDetailView+NoteSection.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/06.
//

import SwiftUI
import VRCKit

extension UserDetailView {
    var noteSection: some View {
        SectionView {
            Text("Note")
                .font(.subheadline)
                .foregroundStyle(Color.gray)
            TextField("Enter note", text: $note, axis: .vertical)
                .focused($isFocusedNoteField)
                .font(.body)
        }
    }
}
