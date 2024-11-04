//
//  AuthenticationPreviewService.swift
//  VRCKit
//
//  Created by makinosp on 2024/07/06.
//

import MemberwiseInit
import VRCKit

@MemberwiseInit
final actor AuthenticationPreviewService: APIService, AuthenticationServiceProtocol {
    let client: APIClient

    func exists(userId: String) async throws -> Bool { true }

    func loginUserInfo() async throws -> Either<User, VerifyType> {
        .left(PreviewData.shared.previewUser)
    }

    func verify2FA(verifyType: VerifyType, code: String) async throws -> Bool { true }

    func verifyAuthToken() async throws -> Bool { true }

    func logout() async throws {}
}
