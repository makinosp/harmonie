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
    @State private var selectedLanguage: LanguageTag?
    @State var status: UserStatus
    @State var statusDescription: String
    @State var bio: String
    @State var languageTags: [LanguageTag]
    @State var bioLinks: [URL]

    init(user: User) {
        _status = State(initialValue: user.status)
        _statusDescription = State(initialValue: user.statusDescription)
        _bio = State(initialValue: user.bio ?? "")
        _languageTags = State(initialValue: user.tags.languageTags)
        _bioLinks = State(initialValue: user.bioLinks.elements)
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
                Section {
                    Button {
                        isPresentedLanguagePicker = true
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
                .listSectionSpacing(.compact)
                Section("Bio Links") {
                    ForEach(bioLinks) { url in
                        Link(url.description, destination: url)
                    }
                }
                Section {
                    Button {
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
                .listSectionSpacing(.compact)
            }
            .toolbar { toolbarContents }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $isPresentedLanguagePicker) {
            LanguagePickerView(selectedLanguage: $selectedLanguage)
                .presentationDetents([.medium])
        }
        .onChange(of: selectedLanguage) {
            if let selectedLanguage = selectedLanguage, !languageTags.contains(selectedLanguage) {
                languageTags.append(selectedLanguage)
                self.selectedLanguage = nil
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
