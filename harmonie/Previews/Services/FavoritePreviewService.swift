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

    let favoriteGroups = FavoriteType.allCases.flatMap { type in
        (1...3).map { number in
            FavoriteGroup(
                id: "fvgrp_\(UUID().uuidString)",
                displayName: "\(type.rawValue.capitalized) Group \(number)",
                name: "group_\(number)",
                ownerId: PreviewData.shared.previewUser.id,
                tags: [],
                type: type,
                visibility: .private
            )
        }
    }

    func listFavoriteGroups() async throws -> [FavoriteGroup] {
        favoriteGroups
    }

    func listFavorites(type: FavoriteType) async throws -> [Favorite] {
        // No implementation required
        []
    }

    func listFavorites(n: Int, offset: Int, type: FavoriteType, tag: String?) async throws -> [Favorite] {
        // No implementation required
        []
    }

    func fetchFavoriteList(favoriteGroups: [FavoriteGroup], type: FavoriteType) async throws -> [FavoriteList] {
        favoriteGroups.enumerated().map { (index, group) in
            switch (index, group.type) {
            case (6, .friend):
                FavoriteList(
                    id: group.id,
                    favorites: PreviewData.shared.onlineFriends.prefix(5).map { friend in
                        Favorite(favoriteId: friend.id, type: group.type)
                    }
                )
            default: FavoriteList(id: group.id, favorites: [])
            }
        }
    }

    public func addFavorite(
        type: FavoriteType,
        favoriteId: String,
        tag: String
    ) async throws -> Favorite {
        Favorite(favoriteId: favoriteId, tags: [tag], type: type)
    }

    func updateFavoriteGroup(
        source: FavoriteGroup,
        displayName: String,
        visibility: FavoriteGroup.Visibility
    ) async throws {
        // No implementation required
    }

    func removeFavorite(favoriteId: String) async throws -> SuccessResponse {
        SuccessResponse(success: .ok)
    }
}

private extension Favorite {
    init(favoriteId: String, tags: [String] = [], type: FavoriteType) {
        self.init(id: UUID().uuidString, favoriteId: favoriteId, tags: tags, type: type)
    }
}
