//
//  ProfileEditViewModel.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/23.
//

import Observation
import VRCKit

@Observable @MainActor
final class ProfileEditViewModel {
    var editingUserInfo: EditableUserInfo
    @ObservationIgnored private let id: User.ID

    init(user: User) {
        editingUserInfo = EditableUserInfo(detail: user)
        id = user.id
    }

    func saveProfile(service: UserServiceProtocol) async throws {
        try await service.updateUser(
            id: id,
            editedInfo: editingUserInfo
        )
    }

    func removeTag(_ target: LanguageTag) {
        editingUserInfo.tags.languageTags = editingUserInfo.tags.languageTags.filter { $0 != target }
    }
}
