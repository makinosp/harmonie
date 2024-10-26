//
//  FavoritePreviewService.swift
//  VRCKit
//
//  Created by makinosp on 2024/07/13.
//

import Foundation
import MemberwiseInit
import VRCKit

@MemberwiseInit
final actor FavoritePreviewService: APIService, FavoriteServiceProtocol {
    let client: APIClient

    func listFavoriteGroups() async throws -> [FavoriteGroup] {
        FavoriteType.allCases.flatMap { type in
            (1...3).map { index in
                FavoriteGroup(
                    id: "fvgrp_\(UUID().uuidString)",
                    displayName: "\(type.rawValue.capitalized) Group \(index)",
                    name: "group_\(index)",
                    ownerId: PreviewDataProvider.shared.previewUser.id,
                    tags: [],
                    type: type,
                    visibility: .private
                )
            }
        }
    }

    func listFavorites(type: FavoriteType) async throws -> [Favorite] {
        switch type {
        case .friend:
            PreviewDataProvider.shared.onlineFriends.prefix(5).map { friend in
                Favorite(id: UUID().uuidString, favoriteId: friend.id, tags: ["group_1"], type: .friend)
            }
        default: []
        }
    }

    func fetchFavoriteList(favoriteGroups: [FavoriteGroup], type: FavoriteType) async throws -> [FavoriteList] {
        []
    }

    public func addFavorite(
        type: FavoriteType,
        favoriteId: String,
        tag: String
    ) async throws -> Favorite {
        Favorite(id: UUID().uuidString, favoriteId: favoriteId, tags: [tag], type: type)
    }

    func updateFavoriteGroup(
        source: FavoriteGroup,
        displayName: String,
        visibility: FavoriteGroup.Visibility
    ) async throws {}

    func removeFavorite(favoriteId: String) async throws -> SuccessResponse {
        SuccessResponse(success: .ok)
    }
}
