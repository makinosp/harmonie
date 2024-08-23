//
//  ProfileEditView.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/21.
//

import SwiftUI
import VRCKit

struct ProfileEditView: View {
    @EnvironmentObject var appVM: AppViewModel
    @Environment(\.dismiss) private var dismiss
    @StateObject private var profileEditVM: ProfileEditViewModel
    @State private var isPresentedLanguagePicker = false
    @State private var selectedLanguage: LanguageTag?
    
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
        .onChange(of: selectedLanguage) {
            if let selectedLanguage = selectedLanguage,
               !profileEditVM.editingUserInfo.tags.languageTags.contains(selectedLanguage) {
                profileEditVM.editingUserInfo.tags.languageTags.append(selectedLanguage)
                self.selectedLanguage = nil
            }
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
            TextField("Status Description", text: $profileEditVM.editingUserInfo.statusDescription)
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
    
    func saveUserInfo(id: String) async {
        let service = appVM.isDemoMode
        ? UserPreviewService(client: appVM.client)
        : UserService(client: appVM.client)
        do {
            try await service.updateUser(
                id: id,
                editedInfo: profileEditVM.editingUserInfo
            )
        } catch {
            appVM.handleError(error)
        }
    }
}
