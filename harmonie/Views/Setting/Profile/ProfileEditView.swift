//
//  ProfileEditView.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/21.
//

import AsyncSwiftUI
import VRCKit

struct ProfileEditView: View {
    @EnvironmentObject private var appVM: AppViewModel
    @Environment(\.dismiss) private var dismiss
    @StateObject private var profileEditVM: ProfileEditViewModel
    @State private var isPresentedLanguagePicker = false
    @State private var isPresentedURLEditor = false
    @State private var isRequesting = false
    @State private var selectedLanguage: LanguageTag?
    @State private var inputtedURL: URL?

    init(user: User) {
        _profileEditVM = StateObject(wrappedValue: ProfileEditViewModel(user: user))
    }

    var body: some View {
        NavigationStack {
            Form {
                statusSection
                descriptionSection
                languageSection
                bioLinksSection
            }
            .toolbar { toolbarContents }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $isPresentedLanguagePicker) {
            LanguagePickerView(selectedLanguage: $selectedLanguage)
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $isPresentedURLEditor) {
            URLEditorView(inputtedURL: $inputtedURL)
                .presentationDetents([.medium])
        }
        .onChange(of: selectedLanguage) {
            if let selectedLanguage = selectedLanguage,
               !profileEditVM.editingUserInfo.tags.languageTags.contains(selectedLanguage) {
                profileEditVM.editingUserInfo.tags.languageTags.append(selectedLanguage)
                self.selectedLanguage = nil
            }
        }
        .onChange(of: inputtedURL) {
            guard let inputtedURL = inputtedURL else { return }
            profileEditVM.editingUserInfo.bioLinks.append(inputtedURL)
            self.inputtedURL = nil
        }
    }

    var statusSection: some View {
        Section("Status") {
            Picker(selection: $profileEditVM.editingUserInfo.status) {
                ForEach(UserStatus.allCases) { status in
                    Text(status.description).tag(status)
                }
            } label: {
                Label {
                    Text("Status")
                } icon: {
                    Image(systemName: "circle.fill")
                        .foregroundStyle(profileEditVM.editingUserInfo.status.color)
                }
            }
            TextField(
                "Status Description",
                text: $profileEditVM.editingUserInfo.statusDescription
            )
        }
    }

    var descriptionSection: some View {
        Section("Description") {
            TextEditor(text: $profileEditVM.editingUserInfo.bio)
        }
    }

    @ViewBuilder var languageSection: some View {
        Section("Language") {
            ForEach(profileEditVM.editingUserInfo.tags.languageTags) { tag in
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
    }

    @ViewBuilder var bioLinksSection: some View {
        Section("Bio Links") {
            ForEach(profileEditVM.editingUserInfo.bioLinks) { url in
                Link(destination: url) {
                    Label {
                        Text(url.description)
                    } icon: {
                        Image(systemName: "link")
                            .foregroundStyle(Color(uiColor: .label))
                    }
                }
                .swipeActions {
                    Button(role: .destructive) {
                            // Delete action
                    } label: {
                        Label {
                            Text("Delete")
                        } icon: {
                            Image(systemName: "message.badge")
                        }
                    }
                }
            }
        }
        Section {
            Button {
                isPresentedURLEditor = true
            } label: {
                Label("Add", systemImage: "plus")
            }
        }
        .listSectionSpacing(.compact)
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
            AsyncButton {
                await saveProfileAction()
            } label: {
                if isRequesting {
                    ProgressView()
                } else {
                    Text("Save")
                }
            }
            .disabled(isRequesting)
        }
    }

    private func saveProfileAction() async {
        let service = appVM.isDemoMode
        ? UserPreviewService(client: appVM.client)
        : UserService(client: appVM.client)
        isRequesting = true
        do {
            defer { isRequesting = false }
            try await profileEditVM.saveProfile(service: service)
            dismiss()
        } catch {
            appVM.handleError(error)
        }
    }
}