//
//  UserNotePreviewService.swift
//  VRCKit
//
//  Created by makinosp on 2024/07/14.
//

import Foundation
import MemberwiseInit
import VRCKit

@MemberwiseInit
final actor UserNotePreviewService: APIService, UserNoteServiceProtocol {
    let client: APIClient

    func updateUserNote(
        targetUserId: String,
        note: String
    ) async throws -> UserNoteResponse {
        UserNoteResponse(
            id: UUID().uuidString,
            targetUserId: targetUserId,
            note: note,
            userId: UUID().uuidString,
            createdAt: Date()
        )
    }

    func clearUserNote(targetUserId: String) async throws {}
}
