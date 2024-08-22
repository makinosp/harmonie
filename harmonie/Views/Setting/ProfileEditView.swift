//
//  ProfileEditView.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/21.
//

import SwiftUI
import VRCKit

struct ProfileEditView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isPresentedLanguagePicker = false
    @State private var addedLanguage: LanguageTag?
    @State var status: UserStatus
    @State var statusDescription: String
    @State var bio: String
    @State var languageTags: [LanguageTag]

    init(user: User) {
        _status = State(initialValue: user.status)
        _statusDescription = State(initialValue: user.statusDescription)
        _bio = State(initialValue: user.bio ?? "")
        _languageTags = State(initialValue: user.tags.languageTags)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Status") {
                    Picker(selection: $status) {
                        ForEach(UserStatus.allCases) { status in
                            Text(status.description).tag(status)
                        }
                    } label: {
                        Label {
                            Text("Status")
                        } icon: {
                            Image(systemName: "circle.fill")
                                .foregroundStyle(status.color)
                        }
                    }
                    TextField("Status Description", text: $statusDescription)
                }
                Section("Description") {
                    TextEditor(text: $bio)
                }
                Section("Language") {
                    ForEach(languageTags) { tag in
                        Text(tag.description)
                            .swipeActions {
                                Button(role: .destructive) {
                                    // Delete action
                                } label: {
                                    Text("Delete")
                                }
                            }
                    }
                }
                Button {
                    isPresentedLanguagePicker = true
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
            .toolbar { toolbarContents }
        }
        .sheet(isPresented: $isPresentedLanguagePicker) {
            languagePicker.presentationDetents([.medium])
        }
    }

    var languagePicker: some View {
        Form {
            Picker("Languages", selection: $addedLanguage) {
                ForEach(LanguageTag.allCases) { languageTag in
                    Text(languageTag.description)
                        .tag(LanguageTag?.some(languageTag))
                }
            }
            .pickerStyle(.inline)
        }
        .onChange(of: addedLanguage) {
            if let addedLanguage = addedLanguage, !languageTags.contains(addedLanguage) {
                languageTags.append(addedLanguage)
                self.addedLanguage = nil
            }
        }
    }

    @ToolbarContentBuilder var toolbarContents: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button {
                dismiss()
            } label: {
                Text("Cancel")
            }
        }
        ToolbarItem {
            Button {
                print("Saving!")
            } label: {
                Text("Save")
            }
        }
    }
}
