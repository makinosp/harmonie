//
//  ProfileEditView.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/21.
//

import AsyncSwiftUI
import VRCKit

struct ProfileEditView: View {
    @Environment(AppViewModel.self) var appVM
    @Environment(\.dismiss) private var dismiss
    @State private var profileEditVM: ProfileEditViewModel
    @State private var isPresentedLanguagePicker = false
    @State private var isPresentedURLEditor = false
    @State private var isRequesting = false
    @State private var selectedLanguage: LanguageTag?
    @State private var inputtedURL: URL?

    init(user: User) {
        profileEditVM = ProfileEditViewModel(user: user)
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
        .task {
            await _ = appVM.login()
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

    private var statusSection: some View {
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

    private var descriptionSection: some View {
        Section("Description") {
            TextEditor(text: $profileEditVM.editingUserInfo.bio)
        }
    }

    private var languageSection: some View {
        Group {
            Section("Language") {
                ForEach(profileEditVM.editingUserInfo.tags.languageTags) { tag in
                    Text(tag.description)
                        .swipeActions {
                            Button(role: .destructive) {
                                profileEditVM.removeTag(tag)
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
                    Label {
                        Text("Add")
                    } icon: {
                        IconSet.plusCircleFilled.icon.symbolRenderingMode(.multicolor)
                    }
                }
            }
            .listSectionSpacing(.compact)
        }
    }

    private var bioLinksSection: some View {
        Group {
            Section("Social Links") {
                ForEach(profileEditVM.editingUserInfo.bioLinks) { url in
                    Link(destination: url) {
                        Label(url.description, systemImage: IconSet.link.systemName)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            profileEditVM.removeUrl(url)
                        } label: {
                            Text("Delete")
                        }
                    }
                }
            }
            Section {
                Button {
                    isPresentedURLEditor = true
                } label: {
                    Label {
                        Text("Add")
                    } icon: {
                        IconSet.plusCircleFilled.icon.symbolRenderingMode(.multicolor)
                    }
                }
            }
            .listSectionSpacing(.compact)
        }
    }

    @ToolbarContentBuilder private var toolbarContents: some ToolbarContent {
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
        defer {
            isRequesting = false
            dismiss()
        }
        isRequesting = true
        do {
            guard let user = appVM.user else { throw ApplicationError.userIsNotSetError }
            try await profileEditVM.saveProfile(service: appVM.services.userService)
            appVM.user = User(user: user, editedUserInfo: profileEditVM.editingUserInfo)
        } catch {
            appVM.handleError(error)
        }
    }
}
