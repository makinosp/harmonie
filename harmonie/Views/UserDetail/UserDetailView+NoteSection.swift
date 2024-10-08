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
            Text(user.note)
                .font(.body)
        }
        .groupBoxStyle(.card)
        .onTapGesture {
            isPresentedNoteEditor = true
        }
        .sheet(isPresented: $isPresentedNoteEditor) {
            NoteEditView(initialValue: user.note, userId: user.id) { text in
                user.note = text
            }
        }
    }
}
