//
//  FavoritePreviewService.swift
//  VRCKit
//
//  Created by makinosp on 2024/07/13.
//

import Foundation
import VRCKit

final actor FavoritePreviewService: APIService, FavoriteServiceProtocol {
    let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func listFavoriteGroups() async throws -> [FavoriteGroup] {
        [
            FavoriteGroup(
                id: "fvgrp_\(UUID().uuidString)",
                displayName: "DemoGroup",
                name: "group_1",
                tags: [],
                type: .friend,
                visibility: .private
            )
        ]
    }

    func listFavorites(
        n: Int = 60,
        type: FavoriteType,
        tag: String? = nil
    ) async throws -> [Favorite] {
        switch type {
        case .friend:
            PreviewDataProvider.shared.onlineFriends.prefix(5).map { friend in
                Favorite(id: UUID().uuidString, favoriteId: friend.id, tags: ["group_1"], type: .friend)
            }
        default:
            []
        }
    }

    func fetchFavoriteGroupDetails(favoriteGroups: [FavoriteGroup]) async throws -> [FavoriteDetail] {
        []
    }

    public func addFavorite(
        type: FavoriteType,
        favoriteId: String,
        tag: String
    ) async throws -> Favorite {
        Favorite(id: UUID().uuidString, favoriteId: favoriteId, tags: [tag], type: type)
    }

    func removeFavorite(favoriteId: String) async throws -> SuccessResponse {
        SuccessResponse(success: ResponseMessage(message: "OK", statusCode: 200))
    }
}
