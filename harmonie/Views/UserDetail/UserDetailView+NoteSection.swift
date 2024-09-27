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
        GroupBox("Note") {
            TextField("Enter note", text: $note, axis: .vertical)
                .focused($isFocusedNoteField)
                .font(.body)
        }
        .groupBoxStyle(.card)
    }
}
