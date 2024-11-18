//
//  WorldPreviewService.swift
//  VRCKit
//
//  Created by makinosp on 2024/09/09.
//

import Foundation
import MemberwiseInit
import VRCKit

@MemberwiseInit
final actor WorldPreviewService: APIService, WorldServiceProtocol {
    let client: APIClient

    func fetchWorld(worldId: String) async throws -> World {
        PreviewData.worldList.first { $0.id == worldId } ?? PreviewData.bar
    }

    func fetchFavoritedWorlds() async throws -> [FavoriteWorld] {
        [PreviewData.chillRoom, PreviewData.nightCity, PreviewData.chinatown].map { world in
            FavoriteWorld(
                world: world,
                favoriteId: "fvrt_\(UUID())",
                favoriteGroup: PreviewData.favoriteGroups[0].name
            )
        }
    }

    func fetchFavoritedWorlds(n: Int, offset: Int) async throws -> [FavoriteWorld] {
        // No implementation required
        []
    }
}
