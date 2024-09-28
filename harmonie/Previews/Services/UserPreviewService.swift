//
//  UserPreviewService.swift
//  VRCKit
//
//  Created by makinosp on 2024/07/14.
//

import VRCKit

final actor UserPreviewService: APIService, UserServiceProtocol {
    let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func fetchUser(userId: String) async throws -> UserDetail {
        PreviewDataProvider.shared.userDetails.first { $0.id == userId }!
    }

    func updateUser(id: String, editedInfo: EditableUserInfo) async throws {}
}
