//
//  ProfileEditViewModel.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/23.
//

import Observation
import VRCKit

@Observable
class ProfileEditViewModel {
    var editingUserInfo: EditableUserInfo
    @ObservationIgnored private let id: String

    init(user: User) {
        editingUserInfo = EditableUserInfo(detail: user)
        id = user.id
    }

    func saveProfile(service: any UserServiceProtocol) async throws {
        try await service.updateUser(
            id: id,
            editedInfo: editingUserInfo
        )
    }
}
