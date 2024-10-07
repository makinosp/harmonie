//
//  NoteEditView.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/07.
//

import AsyncSwiftUI
import VRCKit

struct NoteEditView: View, UserNoteServiceRepresentable {
    @Environment(AppViewModel.self) var appVM
    @Environment(\.dismiss) private var dismiss
    @FocusState var isFocusedNoteField
    @State private var text: String
    @State private var isRequesting = false
    private let userId: String

    init(initialValue: String, userId: String) {
        text = initialValue
        self.userId = userId
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Enter note", text: $text, axis: .vertical)
                    .lineLimit(5...10)
            }
            .scrollDisabled(true)
            .contentMargins(.vertical, .zero)
            .toolbar { toolbarItems }
            .navigationTitle("Edit Note")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    @ToolbarContentBuilder private var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") {
                dismiss()
            }
        }
        ToolbarItem(placement: .confirmationAction) {
            AsyncButton {
                await saveAction()
            } label: {
                if isRequesting {
                    ProgressView()
                } else {
                    Text("Save")
                }
            }
        }
    }

    func saveAction() async {
        defer { isRequesting = false }
        isRequesting = true
        do {
            if text.isEmpty {
                try await userNoteService.clearUserNote(targetUserId: userId)
            } else {
                _ = try await userNoteService.updateUserNote(
                    targetUserId: userId,
                    note: text
                )
            }
            dismiss()
        } catch {
            appVM.handleError(error)
        }
    }
}

#Preview {
    PreviewContainer {
        NoteEditView(initialValue: "initialValue", userId: "")
    }
}
