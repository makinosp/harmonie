//
//  AuthenticationPreviewService.swift
//  VRCKit
//
//  Created by makinosp on 2024/07/06.
//

import VRCKit

final actor AuthenticationPreviewService: APIService, AuthenticationServiceProtocol {
    let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func exists(userId: String) async throws -> Bool { true }

    func loginUserInfo() async throws -> UserOrRequires {
        PreviewDataProvider.shared.previewUser
    }

    func verify2FA(verifyType: VerifyType, code: String) async throws -> Bool { true }

    func verifyAuthToken() async throws -> Bool { true }

    func logout() async throws {}
}
