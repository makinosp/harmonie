//
//  ProfileEditViewModel.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/23.
//

import Foundation
import VRCKit

class ProfileEditViewModel: ObservableObject {
    @Published var editingUserInfo: EditableUserInfo
    private let id: String

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
